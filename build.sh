#!/bin/sh
#shellcheck disable=SC2185

# check target
case "$*" in
    *--target=*)
        _args="$*"
        _TARGET="${_args#*--target=}" ;;
    *)
        _TARGET="arm-apple-darwin9" ;;
esac

# check for dependencies
for dep in "$_TARGET-clang" "$_TARGET-clang++" "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" "$_TARGET-sdkpath" ldid dpkg-deb mv cp; do
    if ! command -v "$dep" > /dev/null; then
        printf "ERROR: Missing dependency %s\n" "$dep"
        exit 1
    fi
done

# check for apple strip
_strip_version=$("$_TARGET-strip" --version 2> /dev/null)
case "$_strip_version" in
    *GNU*) printf "ERROR: GNU strip is not supported\n"; exit 1;;
esac

# check for gnu make
if command -v gmake > /dev/null; then
    _MAKE="gmake"
elif command -v make > /dev/null; then
    _make_version="$(make --version)"
    case "$_make_version" in
        *GNU*) _MAKE="make" ;;
        *) printf "ERROR: Non-GNU make detected. Please install GNU make.\n" ;;
    esac
else
    printf "ERROR: No make command detected. Please install GNU make.\n"
    exit 1
fi

# check for gnu patch
if command -v gpatch > /dev/null; then
    _PATCH="gpatch"
elif command -v make > /dev/null; then
    _patch_version="$(patch --version)"
    case "$_patch_version" in
        *GNU*) _PATCH="patch" ;;
        *) printf "ERROR: Non-GNU patch detected. Please install GNU patch.\n" ;;
    esac
else
    printf "ERROR: No patch command detected. Please install GNU patch.\n"
    exit 1
fi

# check for gnu find
if command -v gfind > /dev/null; then
    _FIND="gfind"
elif command -v find > /dev/null; then
    _find_version="$(find --version)"
    case "$_find_version" in
        *GNU*) _FIND="find" ;;
        *) printf "ERROR: Non-GNU find detected. Please install GNU find.\n" ;;
    esac
else
    printf "ERROR: No find command detected. Please install GNU find.\n"
    exit 1
fi

# assign environment variables
_BSROOT="${0%/*}"
_BSROOT="$(cd "$_BSROOT" && pwd)"
_PKGDIR="$_BSROOT/pkgs"
_SDK="$("$_TARGET-sdkpath")"
export _PKGDIR _BSROOT _SDK _TARGET _MAKE _FIND
export TERM="xterm-256color"

# check if a required build dependency is missing
# we rebuild if the return code is 1
# rebuild if $_PKGDIR/$1/package/usr/include and $_PKGDIR/$1/package/usr/lib are both missing
# if $2 = dryrun, then we rebuild the first time this function is run, but not again until the next time the script is run, even if the package is missing
# check what packages are already built this run by adding them to the _BUILTPKGS variable
hasbeenbuilt() {
    if [ "$2" = "dryrun" ]; then
        if [ -z "$_BUILTPKGS" ]; then
            _BUILTPKGS="$1"
            return 1
        else
            for pkg in $_BUILTPKGS; do
                if [ "$pkg" = "$1" ]; then
                    return 0
                fi
            done
            _BUILTPKGS="$_BUILTPKGS $1"
            return 1
        fi
    fi
    if [ -d "$_PKGDIR/$1/package/usr/include" ] && [ -d "$_PKGDIR/$1/package/usr/lib" ]; then
        return 0
    else
        return 1
    fi
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
    case "$*" in
        *--no-tmpfs*) export _SDKPATH="$_BSROOT/sdk" ;;
        *) export _SDKPATH="/tmp/sdk" ;;
    esac
    if ! [ "$2" = "dryrun" ]; then
        rm -rf "$_SDKPATH"
        cp -r "$_SDK" "$_SDKPATH"
    fi
    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$_PKGDIR/$dep" ]; then
                if [ "$1" = "-r" ] || ! hasbeenbuilt "$dep" "$2"; then
                    printf "Building dependency %s\n" "$dep"
                    [ "$2" = "dryrun" ] || mv "$_SDKPATH" "$_SDKPATH.tmp"
                    build "$dep" "$1" "$2"
                    [ "$2" = "dryrun" ] || mv "$_SDKPATH.tmp" "$_SDKPATH"
                    if ! [ "$2" = "dryrun" ]; then
                        [ -d "$_PKGDIR/$dep/package/usr/include" ] || [ -d "$_PKGDIR/$dep/package/usr/lib" ] || { printf "Failed to build dependency %s\n" "$dep"; exit 1; }
                    fi
                fi
                printf "Including dependency %s\n" "$dep"
                if ! [ "$2" = "dryrun" ]; then
                    cp -r "$_PKGDIR/$dep/package/usr/include" "$_SDKPATH/usr"
                    cp -r "$_PKGDIR/$dep/package/usr/lib" "$_SDKPATH/usr"
                fi
            fi
        done < dependencies.txt
    fi
}

build() {
    (
    hasbeenbuilt "$1" "$3" && return 0
    printf "Building %s...\n" "${1##*/}"
    export _PKGROOT="$_PKGDIR/$1"
    cd "$_PKGROOT" || exit 1
    includedeps "$2" "$3"
    [ -d "$_PKGROOT/sdk" ] && cp -r "$_PKGROOT/sdk"/* "$_SDKPATH"
    if ! [ "$3" = "dryrun" ]; then
        ./fetch.sh
        applypatches
        ./build.sh
    fi
    rm -rf "$_SDKPATH"
    )
}

buildall() {
    for pkg in "$_PKGDIR"/*; do
        pkg="${pkg##*/}"
        build "$pkg" -r "$1" || { printf "Failed to build %s\n" "$pkg"; exit 1; }
    done
}

if [ -z "$1" ]; then
    printf "Usage: build.sh <option> [--target=tripple] [--no-tmpfs]
    <package name> [-r]     - Build a single package, specify -r to rebuild dependencies
    pkg <package name> [-r] - Build a single package and add it to the repo
    all                     - Build all packages
    pkgall                  - Build all packages and add them to the repo
    dryrun                  - Pretend to build all packages
    listpkgs                - List all packages
    --target                - Specify a target other than arm-apple-darwin9
    --no-tmpfs              - Do not use tmpfs for temporary sdks (use if you have limited RAM)\n"
    exit 1
fi

if [ "$1" = "pkgall" ]; then
    buildall
    "$_FIND" . -iname "*.deb" -exec cp {} "$_BSROOT/debs" \;
elif [ "$1" = "all" ]; then
    buildall
elif [ "$1" = "listpkgs" ]; then
    for pkg in "$_PKGDIR"/*; do
        printf "%s\n" "${pkg##*/}"
    done
elif [ "$1" = "pkg" ]; then
    build "$2" "$3"
    "$_FIND" "$_PKGDIR/$2" -iname "*.deb" -exec cp {} "$_BSROOT/debs" \;
elif [ -d "$_PKGDIR/$1" ]; then
    build "$@"
elif [ "$1" = dryrun ]; then
    buildall dryrun
else
    printf "ERROR: Package %s not found!\n" "$1"
    exit 1
fi
