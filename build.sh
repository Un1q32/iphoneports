#!/bin/sh
# shellcheck disable=2031

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

if [ -f pkglock ]; then
    read -r lockpid < pkglock
    if kill -0 "$lockpid" 2> /dev/null; then
        printf '%s\n' "Waiting for PID $lockpid to finish..."
        while kill -0 "$lockpid" 2> /dev/null; do
            sleep 1
        done
    fi
fi

printf '%s' "$$" > pkglock

pkgdir="$bsroot/pkgs"
export TERM="xterm-256color"

[ -f defaulttarget.txt ] && IFS= read -r defaulttarget < defaulttarget.txt

case "$*" in
    *--no-tmpfs*) export _TMP="$bsroot" ;;
    *) export _TMP="/tmp" ;;
esac

case "$*" in
    *--target=*) _TARGET="$*" ; _TARGET="${_TARGET#*--target=}" ; export _TARGET="${_TARGET%% *}" ;;
    *) export _TARGET="$defaulttarget" ;;
esac

case "$*" in
    *-j*)
        _JOBS="$*" ; _JOBS="${_JOBS#*-j}" ; _JOBS="${_JOBS%% *}"
        case $_JOBS in
            ''|*[!0-9]*) unset _JOBS ;;
            *) export _JOBS ;;
        esac
    ;;
esac

if [ -z "$_JOBS" ]; then
    if command -v nproc > /dev/null; then
        cpus=$(nproc)
    else
        cpus=$(sysctl -n hw.ncpu 2> /dev/null)
        [ -z "$cpus" ] && cpus=1
    fi

    _JOBS=$((cpus * 2 / 3))
    [ "$_JOBS" = 0 ] && _JOBS=1
    export _JOBS
fi

case $_DPKGARCH in
    iphoneos-*) _ENT="$bsroot/ios-entitlements.xml" ;;
    *) _ENT= ;;
esac
export _ENT

: > "$bsroot/.builtpkgs"

strip_and_sign() {
    "$_TARGET-strip" "$@" 2>/dev/null || true
    [ "$_SUBSYSTEM" != "macos" ] || [ "$_CPU" = "arm64" ] || [ "$_CPU" = "arm64e" ] && ldid -S"$_ENT" "$@"
}

error() {
    printf '\033[1;31mError:\033[0m %s\n' "$1"
    rm -f "$bsroot/pkglock"
    exit 1
}

depcheck() {
    for dep in "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" "$_TARGET-sdkpath" "$_TARGET-install_name_tool" ldid dpkg-deb fakeroot automake autoreconf m4 yacc ctags tar gzip bzip2 xz zstd ninja sed pgrep meson cmake curl git; do
        if ! command -v "$dep" > /dev/null; then
            error "Missing dependency: $dep"
        fi
    done

    case $_TARGET in
        x86_64*|i386-*)
            if ! command -v nasm > /dev/null; then
                error "Missing dependency: nasm"
            fi
        ;;
    esac

    if command -v gmake > /dev/null; then
        _MAKE="gmake"
    elif command -v make > /dev/null; then
        _make_version="$(make --version 2>/dev/null)"
        case "$_make_version" in
            *GNU*) _MAKE="make" ;;
            *) error "Missing dependency: GNU make" ;;
        esac
    else
        error "Missing dependency: GNU make"
    fi

    if command -v gpatch > /dev/null; then
        gpatch="gpatch"
    elif command -v patch > /dev/null; then
        _patch_version="$(patch --version 2>/dev/null)"
        case "$_patch_version" in
            *GNU*) gpatch="patch" ;;
            *) error "Missing dependency: GNU patch" ;;
        esac
    else
        error "Missing dependency: GNU patch"
    fi

    if command -v gtar > /dev/null; then
        gtar="gtar"
    elif command -v make > /dev/null; then
        _tar_version="$(tar --version 2>/dev/null)"
        case "$_tar_version" in
            *GNU*) gtar="tar" ;;
            *) error "Missing dependency: GNU tar" ;;
        esac
    else
        error "Missing dependency: GNU tar"
    fi

    sdk="$("$_TARGET-sdkpath")"

    eval "$(printf '%s' '\
if [ TARGET_OS_IOS = 1 ]; then
    _SUBSYSTEM=ios
elif [ TARGET_OS_OSX = 1 ]; then
    _SUBSYSTEM=macos
elif [ TARGET_OS_WATCH = 1 ]; then
    _SUBSYSTEM=watchos
elif [ TARGET_OS_TV = 1 ]; then
    _SUBSYSTEM=tvos
else
    echo "UNSUPPORTED PLATFORM"
    exit 1
fi
' | "$_TARGET-cc" -E -xc -)"
    _CPU="${_TARGET%%-*}"

    case $_CPU in
        arm64*|aarch64*)
            if [ "$_SUBSYSTEM" = "ios" ]; then
                _DPKGARCH=iphoneos-arm
            else
                _DPKGARCH=darwin-arm64
            fi
            if "$_TARGET-cc" -dM -E - < /dev/null | grep -q __arm64e__; then
                export _CPU=arm64e
            fi
        ;;

        arm*) _DPKGARCH=iphoneos-arm ;;
        x86_64*) _DPKGARCH=darwin-amd64 ;;
        i386) _DPKGARCH=darwin-i386 ;;
        ppc64) _DPKGARCH=darwin-ppc64 ;;
        ppc|powerpc) _DPKGARCH=darwin-powerpc ;;
    esac

    export _MAKE _SUBSYSTEM _CPU _DPKGARCH
}

build() {
    if hasbeenbuilt "$1" "$2"; then
        return 0
    fi

    (
    export _PKGROOT="$pkgdir/$1"
    export _PKGNAME="$1"
    cd "$_PKGROOT" || error "Failed to cd to package directory: $1"
    includedeps
    if [ -n "$dryrun" ]; then
        printf '%s\n' "Building $1"
    else
        [ -f fetch.sh ] && ./fetch.sh
        applypatches
        printf '%s\n' "Building $1"
        (
            set -e
            . ./build.sh
        ) || {
            rm -rf pkg "$_SDK"
            return 2
        }
    fi
    rm -rf "$_SDK"
    )

    case $? in
        1) exit 1 ;;
        2) return 1 ;;
    esac

    [ -n "$dryrun" ] && printf '%s\n' "$1" >> "$bsroot/.builtpkgs"
    return 0
}

hasbeenbuilt() {
    if [ -n "$dryrun" ]; then
        while IFS= read -r pkg; do
            if [ "$pkg" = "$1" ]; then
                return 0
            fi
        done < "$bsroot/.builtpkgs"
    elif [ -d "$pkgdir/$1/pkg" ]; then
        return 0
    fi
    return 1
}

applypatches() {
    if [ -d patches ]; then
        for patch in patches/*; do
            printf '%s\n' "Applying patch ${patch##*/}"
            "$gpatch" -p0 < "$patch"
        done
    fi
}

includedeps() {
    if [ -z "$dryrun" ]; then
        if [ -d "$sdk" ]; then
            export _SDK="$_TMP/iphoneports-sdk-$_TARGET"
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
                    build "$dep" || fail=1
                    if [ -z "$dryrun" ]; then
                        if [ -n "$fail" ]; then
                            rm -rf "$_SDK.$dep"
                            error "Failed to build package: $dep"
                        else
                            mv "$_SDK.$dep" "$_SDK"
                        fi
                    fi
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
    [ -d "$pkgdir/$1/pkg" ] || build "$1" || error "Failed to build package: $1"
    if [ -f "$pkgdir/$1/dependencies.txt" ]; then
        while IFS= read -r dep; do
            sysroot "$dep"
        done < "$pkgdir/$1/dependencies.txt"
    fi
    cp -a "$pkgdir/$1"/pkg/* sysroot
}

main() {
    case "$1" in
        all|all-noclean)
            depcheck
            kind=$1
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

                if [ "$kind" != "all-noclean" ]; then
                    rm -rf "$pkg/pkg" "$pkg/src" "$pkg"/*.deb &
                fi
            done
            wait

            for pkg in $pkglist; do
                [ "$kind" = "all-noclean" ] && hasbeenbuilt "$pkg" && continue
                build "$pkg" || error "Failed to build package: $pkg"
                cp -f "$pkgdir/$pkg"/*.deb debs 2> /dev/null
            done
        ;;

        clean)
            [ -z "$2" ] && error "No package specified"
            shift
            for pkg in "$@"; do
                [ -d "$pkgdir/$pkg" ] || error "Package not found: $pkg"
                rm -rf "$pkgdir/$pkg/pkg" "$pkgdir/$pkg/src" "$pkgdir/$pkg"/*.deb
            done
        ;;

        cleanall)
            rm -rf "$pkgdir"/*/pkg "$pkgdir"/*/src "$pkgdir"/*/*.deb "$bsroot"/debs/*.deb "$_TMP"/iphoneports-sdk-* "$bsroot/.builtpkgs"
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
                            [ -f "$pkg/DEBIAN/control" ] && "$EDITOR" "$pkg/DEBIAN/control"
                        fi
                    done < "$pkg/dependencies.txt"
                fi
            done
            rm -rf "$pkgdir/$2/pkg" "$pkgdir/$2/src"
            build "$2" || error "Failed to build package: $2"
            cp -f "$pkgdir/$2"/*.deb "$bsroot/debs" 2> /dev/null
            for pkg in $deppkgs; do
                rm -rf "$pkgdir/$pkg/pkg" "$pkgdir/$pkg/src" "$pkgdir/$pkg"/*.deb
                build "$pkg" || error "Failed to build package: $pkg"
                cp -f "$pkgdir/$pkg"/*.deb debs 2> /dev/null
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
            printf 'Making tarball...\n'
            (
            cd sysroot || exit 1
            "$gtar" --owner 0 --group 0 -czf sysroot.tar.gz ./*
            ) || error "Failed to build sysroot tarball"
            printf 'Done!\n'
        ;;

        bootstrap)
            depcheck
            pkgs='base bzip2 ca-certificates coreutils dash diffutils dpkg gmp grep gtar gzip less libmd libressl ncurses pcre2 readline sed xz zlib zstd lz4 xxhash'
            for pkg in $pkgs; do
                build "$pkg" || error "Failed to build package: $pkg"
            done
            rm -rf sysroot
            mkdir sysroot
            printf 'Building sysroot...\n'
            for pkg in $pkgs; do
                sysroot "$pkg"
                cp -f "$pkgdir/$pkg"/*.deb debs 2> /dev/null
            done
            rm -rf sysroot/DEBIAN
            printf 'Making tarballs...\n'
            (
            cd sysroot || exit 1
            "$gtar" --owner 0 --group 0 -czf bootstrap.tar.gz ./*
            ) || error "Failed to build bootstrap tarball"
            (
            cd debs || exit 1
            "$gtar" --owner 0 --group 0 -czf ../sysroot/debs.tar.gz ./*
            ) || error "Failed to build debs tarball"
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
    all-noclean [pkgs...]   - Same as all but doesn't cleanall first
    clean <pkg> [pkgs...]   - Clean a single package
    cleanall                - Clean all packages
    dryrun [pkgs...]        - Pretend to build all packages, for debugging
    abibreak <pkg>          - ABI break helper, opens all the control files for packages
                              that depend on <pkg> and then rebuilds them
    sysroot <pkg> [pkgs...] - Copy specified package's files and dependencies to sysroot directory
                              Useful for installing packages in environments without dpkg
    bootstrap               - Make a sysroot with base, dpkg, and all their dependencies
    --target                - Specify a target (default: $defaulttarget)
    --no-tmp                - Do not use /tmp for anything, use the current directory instead
    -jN                     - Set the number of jobs passed to programs like make and ninja
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
                rm -rf "$pkgdir/$pkg/pkg" "$pkgdir/$pkg/src" "$pkgdir/$pkg"/*.deb &
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
