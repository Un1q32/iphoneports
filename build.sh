#!/bin/sh

defaulttarget='armv7-apple-darwin11'

help() {
    printf "%s" "\
Usage: build.sh [options] <command>
    <pkg> [pkgs...]         - Build a single package
    all                     - Build all packages
    clean                   - Clean a single package
    cleanall                - Clean all packages
    dryrun                  - Pretend to build all packages
    --target                - Specify a target (default: $defaulttarget)
    --no-tmp                - Do not use /tmp for anything, use the current directory instead
    --no-deps               - Do not add dependencies to the SDK
"
    exit "$1"
}

case "$1" in
    -h|*help) help 0 ;;
esac

error() {
    printf "\033[1;31mError:\033[0m %s\n" "$1"
    [ "$2" != "noexit" ] && exit 1
}

[ "${0%/*}" = "$0" ] && bsroot="." || bsroot="${0%/*}"
cd "$bsroot" || exit 1
bsroot="$PWD"

if [ -z "$1" ]; then
    if [ -f "$bsroot/.args.txt" ]; then
        while read -r line; do
            set -- "$@" "$line"
        done < "$bsroot/.args.txt"
    else
        help 1
    fi
fi

if [ -f "$bsroot/pkglock" ]; then
    lockpid="$(cat "$bsroot/pkglock")"
    if kill -0 "$lockpid" 2> /dev/null; then
        printf "Waiting for PID %s to finish...\n" "$lockpid"
        while kill -0 "$lockpid" 2> /dev/null; do
            sleep 1
        done
    fi
fi

printf '%s' "$$" > "$bsroot/pkglock"

pkgdir="$bsroot/pkgs"
export TERM="xterm-256color"
export _ENT="$bsroot/entitlements.xml"

case "$*" in
    *--no-tmpfs*) export _TMP="$bsroot" ;;
    *) export _TMP="/tmp" ;;
esac

case "$*" in
    *--target=*) _TARGET="$*" ; _TARGET="${_TARGET#*--target=}" ; export _TARGET="${_TARGET%% *}" ;;
    *) export _TARGET="$defaulttarget" ;;
esac

case "$*" in
    *--no-deps*) export _NODEPS="1" ;;
esac

: > "$_TMP/.builtpkgs"
rm -rf "$_TMP"/sdk*

depcheck() {
    for dep in "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" "$_TARGET-sdkpath" ldid dpkg-deb patch fakeroot; do
        if ! command -v "$dep" > /dev/null; then
            error "Missing dependency: $dep"
        fi
    done

    _strip_version=$("$_TARGET-strip" --version 2> /dev/null)
    case "$_strip_version" in
        *GNU*) error "GNU/LLVM strip is not supported, please use Apple's strip" ;;
    esac

    if command -v gmake > /dev/null; then
        _MAKE="gmake"
    elif command -v make > /dev/null; then
        _make_version="$(make --version)"
        case "$_make_version" in
            *GNU*) _MAKE="make" ;;
            *) error "Missing dependency: GNU make" ;;
        esac
    else
        error "Missing dependency: GNU make"
    fi

    if command -v "$_TARGET-otool" > /dev/null; then
        _OTOOL="$_TARGET-otool"
    elif command -v otool > /dev/null; then
        _OTOOL="otool"
    elif command -v llvm-otool > /dev/null; then
        _OTOOL="llvm-otool"
    else
        error "Missing dependency: otool"
    fi

    if command -v "$_TARGET-install_name_tool" > /dev/null; then
        _INSTALLNAMETOOL="$_TARGET-install_name_tool"
    elif command -v install_name_tool > /dev/null; then
        _INSTALLNAMETOOL="install_name_tool"
    elif command -v llvm-install-name-tool > /dev/null; then
        _INSTALLNAMETOOL="llvm-install-name-tool"
    else
        error "Missing dependency: install_name_tool"
    fi

    sdk="$("$_TARGET-sdkpath")"
    export _MAKE _OTOOL _INSTALLNAMETOOL
}

build() {
    if hasbeenbuilt "$1" "$2"; then
        return 0
    fi

    if [ -f "$pkgdir/$1/build.sh" ]; then
        (
        export _PKGROOT="$pkgdir/$1"
        cd "$_PKGROOT" || error "Failed to cd to package directory: $1"
        [ "$_NODEPS" = 1 ] || includedeps "$2"
        [ "$2" = "dryrun" ] || [ -f fetch.sh ] && ./fetch.sh
        [ "$2" = "dryrun" ] || applypatches
        printf "Building %s\n" "$1"
        [ "$2" = "dryrun" ] || ./build.sh
        rm -rf "$_SDK"
        )
    else
        dpkg-deb -b --root-owner-group -Zgzip "$pkgdir/$1" "$bsroot/debs/$1".deb
    fi
    printf "%s\n" "$1" >> "$_TMP/.builtpkgs"
}

buildall() {
    for pkg in "$pkgdir"/*; do
        build "${pkg##*/}" "$1" || error "Failed to build package: ${pkg##*/}"
    done
}

hasbeenbuilt() {
    if [ "$2" = "dryrun" ]; then
        while read -r pkg; do
            if [ "$pkg" = "$1" ]; then
                return 0
            fi
        done < "$_TMP/.builtpkgs"
    elif [ -d "$pkgdir/$1/pkg" ]; then
        return 0
    fi
    return 1
}

applypatches() {
    if [ -d patches ]; then
        for patch in patches/*; do
            printf "Applying patch %s\n" "${patch##*/}"
            patch -p0 < "$patch"
        done
    fi
}

includedeps() {
    if ! [ "$1" = "dryrun" ]; then
        if [ -d "$sdk" ]; then
            export _SDK="$_TMP/sdk"
            cp -a "$sdk" "$_SDK"
        else
            error "SDK not found"
        fi
    fi

    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$pkgdir/$dep" ]; then
                if ! hasbeenbuilt "$dep" "$1"; then
                    printf "Building dependency %s\n" "$dep"
                    [ "$1" = "dryrun" ] || mv "$_SDK" "$_SDK.$dep.bak"
                    build "$dep" "$1"
                    [ "$1" = "dryrun" ] || mv "$_SDK.$dep.bak" "$_SDK"
                fi
                printf "Including dependency %s\n" "$dep"
                [ "$1" = "dryrun" ] || cp -a "$pkgdir/$dep/pkg/"* "$_SDK"
            else
                error "Dependency not found: $dep"
            fi
        done < dependencies.txt
    fi

    if ! [ "$1" = "dryrun" ]; then
        if [ -d sdk ]; then
            cp -a sdk/* "$_SDK"
        fi
    fi
}

main() {
    case "$1" in
        all)
            depcheck
            rm -rf "$pkgdir"/*/pkg "$pkgdir"/*/src
            buildall
            cp -fl "$pkgdir"/*/*.deb "$bsroot/debs" 2>/dev/null
        ;;

        clean)
            rm -rf "$pkgdir/$2/pkg" "$pkgdir/$2/src" "$pkgdir/$2"/*.deb "$bsroot/debs/$2".deb
        ;;

        cleanall)
            rm -rf "$pkgdir"/*/pkg "$pkgdir"/*/src "$pkgdir"/*/*.deb "$bsroot"/debs/*.deb "$_TMP/sdk" "$_TMP/.builtpkgs"
        ;;

        dryrun)
            buildall dryrun
        ;;

        -*)
            shift
            main "$@"
        ;;

        *)
            depcheck
            for pkg in "$@"; do
                [ -d "$pkgdir/$pkg" ] || error "Package not found: $pkg"
            done
            for pkg in "$@"; do
                rm -rf "$pkgdir/$pkg/pkg" "$pkgdir/$pkg/src"
            done
            for pkg in "$@"; do
                build "$pkg" || error "Failed to build package: $pkg"
                cp -fl "$pkgdir/$pkg"/*.deb "$bsroot/debs" 2>/dev/null
            done
        ;;
    esac
}

main "$@"
