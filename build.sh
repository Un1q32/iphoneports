#!/bin/sh
help() {
    printf "%s" "\
Usage: build.sh <command> [options]
    <pkg name>              - Build a single package
    build <pkg names>       - Build all specified packages
    all                     - Build all packages
    clean                   - Clean a single package (remove build files)
    cleanall                - Clean all packages (remove build files)
    dryrun                  - Pretend to build all packages
    list                    - List all packages
    --target                - Specify a target other than arm-apple-darwin11
    --no-tmpfs              - Do not use /tmp for anything (use if you have limited RAM)
    --no-deps               - Do not add dependencies to the SDK
    --help                  - Print this help message
"
}

case "$1" in
    -h|*help) help ; exit 0 ;;
esac

error() {
    printf "\033[1;31mError:\033[0m %s\n" "$1"
    [ "$2" = "noexit" ] || exit 1
}

[ "${0%/*}" = "$0" ] && _BSROOT="." || _BSROOT="${0%/*}"
cd "$_BSROOT" || exit 1
_BSROOT="$PWD"
_PKGDIR="$_BSROOT/pkgs"
TERM="xterm-256color"
export _PKGDIR _BSROOT
export TERM="xterm-256color"

if [ -z "$1" ]; then
    if [ -f "$_BSROOT/.args.txt" ]; then
        while read -r line; do
            set -- "$@" "$line"
        done < "$_BSROOT/.args.txt"
    else
        help
        exit 1
    fi
fi


case "$*" in
    *--no-tmpfs*) export _TMP="$_BSROOT" ;;
    *) export _TMP="/tmp" ;;
esac

case "$*" in
    *--target=*) _TARGET="$*" ; _TARGET="${_TARGET#*--target=}" ; export _TARGET="${_TARGET%% *}" ;;
    *) export _TARGET="arm-apple-darwin11" ;;
esac

case "$*" in
    *--no-deps*) export _NODEPS="1" ;;
esac

: > "$_TMP/.builtpkgs"
rm -rf "$_TMP"/sdk*

depcheck() {
    for dep in "$_TARGET-clang" "$_TARGET-clang++" "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" "$_TARGET-sdkpath" ldid dpkg-deb mv rm fakeroot od tr; do
        if ! command -v "$dep" > /dev/null; then
            error "Missing dependency: $dep"
        fi
    done

    _strip_version=$("$_TARGET-strip" --version 2> /dev/null)
    case "$_strip_version" in
        *GNU*) error "GNU/LLVM strip is not supported."
    esac

    if command -v gmake > /dev/null; then
        _MAKE="gmake"
    elif command -v make > /dev/null; then
        _make_version="$(make --version)"
        case "$_make_version" in
            *GNU*) _MAKE="make" ;;
            *) error "Non-GNU make detected. Please install GNU make." ;;
        esac
    else
        error "No make command detected. Please install GNU make."
    fi

    if command -v gpatch > /dev/null; then
        _PATCH="gpatch"
    elif command -v make > /dev/null; then
        _patch_version="$(patch --version)"
        case "$_patch_version" in
            *GNU*) _PATCH="patch" ;;
            *) error "Non-GNU patch detected. Please install GNU patch." ;;
        esac
    else
        error "No patch command detected. Please install GNU patch."
    fi

    if command -v gcp > /dev/null; then
        _CP="gcp"
    elif command -v cp > /dev/null; then
        _cp_version="$(cp --version)"
        case "$_cp_version" in
            *GNU*) _CP="cp" ;;
            *) error "Non-GNU cp detected. Please install GNU cp." ;;
        esac
    else
        error "No cp command detected. Please install GNU cp."
    fi

    sdk="$("$_TARGET-sdkpath")"
    export _MAKE _PATCH _CP
}

build() {
    if hasbeenbuilt "$1" "$2"; then
        return 0
    fi

    if [ -f "$_PKGDIR/$1/build.sh" ] && [ -f "$_PKGDIR/$1/fetch.sh" ]; then
        (
        export _PKGROOT="$_PKGDIR/$1"
        cd "$_PKGROOT" || error "Failed to cd to package directory: $1"
        [ "$_NODEPS" = 1 ] || includedeps "$2"
        [ "$2" = "dryrun" ] || ./fetch.sh
        [ "$2" = "dryrun" ] || applypatches
        printf "Building %s\n" "$1"
        [ "$2" = "dryrun" ] || ./build.sh
        rm -rf "$_SDK"
        )
    else
        dpkg-deb -b --root-owner-group -Zgzip "$_PKGDIR/$1" "$_BSROOT/debs/$1".deb
    fi
    printf "%s\n" "$1" >> "$_TMP/.builtpkgs"
}

buildall() {
    for pkg in "$_PKGDIR"/*; do
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
    elif [ -d "$_PKGDIR/$1/pkg" ]; then
        return 0
    fi
    return 1
}

applypatches() {
    if [ -d patches ]; then
        for patch in patches/*; do
            printf "Applying patch %s\n" "${patch##*/}"
            "$_PATCH" -p0 < "$patch"
        done
    fi
}

includedeps() {
    if ! [ "$1" = "dryrun" ]; then
        if [ -d "$sdk" ]; then
            export _SDK="$_TMP/sdk"
            "$_CP" -ar "$sdk" "$_SDK"
        else
            error "SDK not found"
        fi
    fi

    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$_PKGDIR/$dep" ]; then
                if ! hasbeenbuilt "$dep" "$1"; then
                    printf "Building dependency %s\n" "$dep"
                    [ "$1" = "dryrun" ] || mv "$_SDK" "$_SDK.$dep.bak"
                    build "$dep" "$1"
                    [ "$1" = "dryrun" ] || mv "$_SDK.$dep.bak" "$_SDK"
                fi
                printf "Including dependency %s\n" "$dep"
                [ "$1" = "dryrun" ] || "$_CP" -ar "$_PKGDIR/$dep/pkg/"* "$_SDK"
            else
                error "Dependency not found: $dep"
            fi
        done < dependencies.txt
    fi

    if ! [ "$1" = "dryrun" ]; then
        if [ -d sdk ]; then
            "$_CP" -ar sdk/* "$_SDK"
        fi
    fi
}

case "$1" in
    all)
        depcheck
        rm -rf "$_PKGDIR"/*/pkg "$_PKGDIR"/*/src
        buildall
        "$_CP" -fl "$_PKGDIR"/*/*.deb "$_BSROOT/debs" 2>/dev/null
    ;;

    list)
        for pkg in "$_PKGDIR"/*; do
            printf "%s\n" "${pkg##*/}"
        done
    ;;

    clean)
        rm -rf "$_PKGDIR/$2/pkg" "$_PKGDIR/$2/src" "$_PKGDIR/$2"/*.deb "$_BSROOT/debs/$2".deb
    ;;

    cleanall)
        rm -rf "$_PKGDIR"/*/pkg "$_PKGDIR"/*/src "$_PKGDIR"/*/*.deb "$_BSROOT"/debs/*.deb "$_TMP/sdk" "$_TMP/.builtpkgs" "$_BSROOT/sdk" "$_BSROOT/.builtpkgs"
    ;;

    dryrun)
        buildall dryrun
    ;;

    build)
        depcheck
        shift
        for pkg in "$@"; do
            [ -d "$_PKGDIR/$pkg" ] || error "Package not found: $pkg"
        done
        for pkg in "$@"; do
            rm -rf "$_PKGDIR/$pkg/pkg" "$_PKGDIR/$pkg/src"
        done
        for pkg in "$@"; do
            build "$pkg" || error "Failed to build package: $pkg"
            "$_CP" -fl "$_PKGDIR/$pkg"/*.deb "$_BSROOT/debs" 2>/dev/null
        done
    ;;

    *)
        if [ -d "$_PKGDIR/$1" ]; then
            depcheck
            rm -rf "$_PKGDIR/$1/pkg" "$_PKGDIR/$1/src"
            build "$1"
            "$_CP" -fl "$_PKGDIR/$1"/*.deb "$_BSROOT/debs" 2>/dev/null
        else
            error "Package not found: $1"
        fi
    ;;
esac
