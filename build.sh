#!/bin/sh

defaulttarget='armv6-apple-darwin10'

[ "${0%/*}" = "$0" ] && bsroot="." || bsroot="${0%/*}"
cd "$bsroot" || exit 1
bsroot="$PWD"

if ! command -v "$EDITOR" >/dev/null 2>&1; then
    for editor in nvim vim vi micro nano; do
        if command -v $editor >/dev/null 2>&1; then
            EDITOR=$editor
            break
        fi
    done
    command -v "$EDITOR" >/dev/null 2>&1 || EDITOR=none
fi

if [ -z "$1" ]; then
    if [ -f "$bsroot/.args.txt" ]; then
        while IFS= read -r line; do
            set -- "$@" "$line"
        done < "$bsroot/.args.txt"
    fi
fi

if [ -f "$bsroot/pkglock" ]; then
    lockpid="$(cat "$bsroot/pkglock")"
    if kill -0 "$lockpid" 2> /dev/null; then
        printf '%s\n' "Waiting for PID $lockpid to finish..."
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

: > "$_TMP/.builtpkgs"
rm -rf "$_TMP"/iphoneports-sdk*

error() {
    printf '\033[1;31mError:\033[0m %s\n' "$1"
    [ "$2" != "noexit" ] && { rm -f "$bsroot/pkglock"; exit 1; }
}

depcheck() {
    for dep in "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" "$_TARGET-sdkpath" ldid dpkg-deb patch fakeroot automake autoreconf m4 yacc ctags tar gzip bzip2 xz zstd ninja sed pgrep; do
        if ! command -v "$dep" > /dev/null; then
            error "Missing dependency: $dep"
        fi
    done

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

    (
    export _PKGROOT="$pkgdir/$1"
    cd "$_PKGROOT" || error "Failed to cd to package directory: $1"
    includedeps
    if [ -n "$dryrun" ]; then
        printf '%s\n' "Building $1"
    else
        [ -f fetch.sh ] && ./fetch.sh
        applypatches
        printf '%s\n' "Building $1"
        ./build.sh
    fi
    rm -rf "$_SDK"
    )

    printf '%s\n' "$1" >> "$_TMP/.builtpkgs"
}

hasbeenbuilt() {
    if [ -n "$dryrun" ]; then
        while IFS= read -r pkg; do
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
            printf '%s\n' "Applying patch ${patch##*/}"
            patch -p0 < "$patch"
        done
    fi
}

includedeps() {
    if [ -z "$dryrun" ]; then
        if [ -d "$sdk" ]; then
            export _SDK="$_TMP/iphoneports-sdk"
            mkdir -p "$_SDK"
            cp -a "$sdk"/* "$_SDK"
        else
            error "SDK not found"
        fi
    fi

    if [ -f dependencies.txt ]; then
        while IFS= read -r dep; do
            if [ -d "$pkgdir/$dep" ]; then
                if ! hasbeenbuilt "$dep"; then
                    printf '%s\n' "Building dependency $dep"
                    [ -z "$dryrun" ] && mv "$_SDK" "$_SDK.$dep"
                    build "$dep"
                    [ -z "$dryrun" ] && mv "$_SDK.$dep" "$_SDK"
                fi
                printf '%s\n' "Including dependency $dep"
                [ -z "$dryrun" ] && cp -a "$pkgdir/$dep/pkg/"* "$_SDK"
            else
                error "Dependency not found: $dep"
            fi
        done < dependencies.txt
    fi

    if [ -z "$dryrun" ]; then
        if [ -d sdk ]; then
            cp -a sdk/* "$_SDK"
        fi
    fi
}

sysroot() {
    if [ -f "$pkgdir/$1/dependencies.txt" ]; then
        while IFS= read -r dep; do
            sysroot "$dep"
        done < "$pkgdir/$1/dependencies.txt"
    fi
    cp -a "$pkgdir/$1"/pkg/* sysroot
}

main() {
    case "$1" in
        all)
            depcheck
            shift
            for pkg in "$pkgdir"/*; do
                unset dontbuild
                for exclude in "$@"; do
                    [ "$pkg" = "$exclude" ] && dontbuild=1
                done
                [ -n "$dontbuild" ] && continue

                if [ -z "$pkglist" ]; then
                    pkglist="${pkg##*/}"
                else
                    pkglist="$pkglist ${pkg##*/}"
                fi

                rm -rf "$pkg/pkg" "$pkg/src" &
            done
            wait

            for pkg in $pkglist; do
                build "$pkg" || error "Failed to build package: $pkg"
                cp -f "$pkgdir/$pkg"/*.deb "$bsroot/debs" 2> /dev/null
            done
        ;;

        clean)
            [ -z "$2" ] && error "No package specified"
            shift
            for pkg in "$@"; do
                [ -d "$pkgdir/$pkg" ] || error "Package not found: $pkg"
                rm -rf "$pkgdir/$pkg/pkg" "$pkgdir/$pkg/src" "$pkgdir/$pkg"/*.deb "$bsroot/debs/$pkg.deb"
            done
        ;;

        cleanall)
            rm -rf "$pkgdir"/*/pkg "$pkgdir"/*/src "$pkgdir"/*/*.deb "$bsroot"/debs/*.deb "$_TMP"/iphoneports-sdk* "$_TMP/.builtpkgs"
        ;;

        dryrun)
            dryrun=1
            if [ -z "$2" ]; then
                for pkg in "$pkgdir"/*; do
                    build "${pkg##*/}" || error "Failed to build package: ${pkg##*/}"
                done
            else
                shift
                for pkg in "$@"; do
                    [ -d "$pkgdir/$pkg" ] || error "Package not found: $pkg"
                done
                for pkg in "$@"; do
                    build "$pkg" || error "Failed to build package: $pkg"
                done
            fi
        ;;

        abibreak)
            [ -z "$2" ] && error "You must specify a package"
            [ "$EDITOR" = "none" ] && error "No suitable text editor found"
            depcheck
            [ -d "$pkgdir/$2" ] || error "Package not found: $2"
            for pkg in "$pkgdir"/*; do
                if [ -f "$pkg/dependencies.txt" ]; then
                    while IFS= read -r dep; do
                        if [ "$dep" = "$2" ]; then
                            if [ -z "$deppkgs" ]; then
                                deppkgs="${pkg##*/}"
                            else
                                deppkgs="$deppkgs ${pkg##*/}"
                            fi
                            "$EDITOR" "$pkg/DEBIAN/control"
                        fi
                    done < "$pkg/dependencies.txt"
                fi
            done
            rm -rf "$pkgdir/$2/pkg" "$pkgdir/$2/src"
            build "$2" || error "Failed to build package: $2"
            cp -f "$pkgdir/$2"/*.deb "$bsroot/debs" 2> /dev/null
            for pkg in $deppkgs; do
                rm -rf "$pkgdir/$pkg/pkg" "$pkgdir/$pkg/src"
                build "$pkg" || error "Failed to build package: $pkg"
                cp -f "$pkgdir/$pkg"/*.deb "$bsroot/debs" 2> /dev/null
            done
        ;;

        sysroot)
            [ -z "$2" ] && error "You must specify a package"
            depcheck
            shift
            for pkg in "$@"; do
                [ -d "$pkgdir/$pkg" ] || error "Package not found: $pkg"
            done
            for pkg in "$@"; do
                build "$pkg" || error "Failed to build package: $pkg"
            done
            rm -rf sysroot
            mkdir sysroot
            printf 'Building sysroot...\n'
            for pkg in "$@"; do
                sysroot "$pkg"
            done
            rm -rf sysroot/DEBIAN
            printf 'Done!\n'
        ;;

        -*)
            shift
            main "$@"
        ;;

        '')
            printf '%s' "\
Usage: build.sh [options] <command>
    <pkg> [pkgs...]         - Build specified packages
    build <pkg> [pkgs...]   - Build specified packages
    all [pkgs...]           - Build all packages (except those specified)
    clean <pkg> [pkgs...]   - Clean a single package
    cleanall                - Clean all packages
    dryrun [pkgs...]        - Pretend to build all packages, for debugging
    abibreak <pkg>          - ABI break helper, opens all the control files for packages
                              that depend on <pkg> and then rebuilds them
    sysroot <pkg> [pkgs...] - Copy specified package's files and dependencies to sysroot directory
                              Useful for installing packages in environments without dpkg
    --target                - Specify a target (default: $defaulttarget)
    --no-tmp                - Do not use /tmp for anything, use the current directory instead
"
            exit 1
        ;;

        *)
            if [ "$1" = "build" ]; then
                shift
            fi
            [ -z "$1" ] && error "You must specify a package"
            depcheck
            for pkg in "$@"; do
                [ -d "$pkgdir/$pkg" ] || error "Package not found: $pkg"
            done
            for pkg in "$@"; do
                rm -rf "$pkgdir/$pkg/pkg" "$pkgdir/$pkg/src" &
            done
            wait
            for pkg in "$@"; do
                build "$pkg" || error "Failed to build package: $pkg"
                cp -f "$pkgdir/$pkg"/*.deb "$bsroot/debs" 2> /dev/null
            done
        ;;
    esac
}

main "$@"
rm -f "$bsroot/pkglock"
