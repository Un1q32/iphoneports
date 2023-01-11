#!/bin/sh
#shellcheck disable=SC2185
case "$*" in
    *--target=*)
        _args="$*"
        _TARGET="${_args#*--target=}"
        ;;
    *)
        _TARGET="arm-apple-darwin9"
        ;;
esac

for dep in "$_TARGET-clang" "$_TARGET-clang++" "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" "$_TARGET-sdkpath" ldid patch dpkg-deb; do
    if ! command -v "$dep" > /dev/null; then
        printf "ERROR: Missing dependency %s\n" "$dep"
        exit 1
    fi
done

_strip_version=$("$_TARGET-strip" --version 2> /dev/null)
case "$_strip_version" in
    *GNU*) printf "ERROR: GNU strip is not supported\n"; exit 1;;
esac

if command -v gmake > /dev/null; then
    _MAKE="gmake"
elif command -v make > /dev/null; then
    _make_version="$(make --version)"
    case "$_make_version" in
        *GNU*) _MAKE="make" ;;
        *) printf "ERROR: Non-GNU make detected. Please install GNU make.\n" ;;
    esac
else
    printf "ERROR: No make detected. Please install GNU make.\n"
    exit 1
fi

if command -v gfind > /dev/null; then
    _FIND="gfind"
elif command -v find > /dev/null; then
    _find_version="$(find --version)"
    case "$_find_version" in
        *GNU*) _FIND="find" ;;
        *) printf "ERROR: Non-GNU find detected. Please install GNU find.\n" ;;
    esac
else
    printf "ERROR: No find detected. Please install GNU find.\n"
    exit 1
fi

_REPODIR="$HOME/iosdev/oldworldordr.github.io"
_BSROOT="${0%/*}"
_BSROOT="$(cd "$_BSROOT" && pwd)"
_PKGDIR="$_BSROOT/pkgs"
_SDK="$("$_TARGET-sdkpath")"
export _PKGDIR _BSROOT _REPODIR _SDK _TARGET _MAKE _FIND
export TERM="xterm-256color"
printf "" > /tmp/.builtpkgs

hasbeenbuilt() {
    while read -r pkg; do
        if [ "$pkg" = "$1" ] && { ! { [ "$2" = "dependency" ] && ! { [ -d "$_PKGDIR/$1/package/usr/include" ] || [ -d "$_PKGDIR/$1/package/usr/lib" ]; }; } || [ "$3" = "dryrun" ]; }; then
            return 0
        fi
    done < /tmp/.builtpkgs
    return 1
}

applypatches() {
    if [ -d patches ]; then
        for patch in patches/*; do
            printf "Applying patch %s\n" "${patch##*/}"
            patch -p1 < "$patch"
        done
    fi
}

includedeps() {
    if [ -f dependencies.txt ]; then
        export _SDKPATH="$_BSROOT/sdk"
        if ! [ "$2" = "dryrun" ]; then
            rm -rf "$_SDKPATH"
            cp -r "$_SDK" "$_BSROOT"
        fi
        while read -r dep; do
            if [ -d "$_PKGDIR/$dep" ]; then
                if [ "$1" = "-r" ] && ! hasbeenbuilt "$dep" dependency "$2"; then
                    printf "Building dependency %s\n" "$dep"
                    build "$dep" -r "$2"
                    if ! [ "$2" = "dryrun" ]; then
                        [ -d "$_PKGDIR/$dep/package/usr/include" ] || [ -d "$_PKGDIR/$dep/package/usr/lib" ] || { printf "Failed to build dependency %s\n" "$dep"; rm /tmp/.builtpkgs; exit 1; }
                    fi
                    printf "%s\n" "$dep" >> /tmp/.builtpkgs
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
    hasbeenbuilt "$1" - "$3" && return 0
    printf "Building %s...\n" "${1##*/}"
    export _PKGROOT="$_PKGDIR/$1"
    cd "$_PKGROOT" || exit 1
    includedeps "$2" "$3"
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
        printf "%s\n" "$pkg" >> /tmp/.builtpkgs
    done
    rm /tmp/.builtpkgs
}

if [ -z "$1" ]; then
    cat << EOF
Usage: build.sh <option> [--target=tripple]
    <package name> [-r]     - Build a single package, specify -r to rebuild dependencies
    pkg <package name> [-r] - Build a single package and add it to the repo
    all                     - Build all packages
    pkgall                  - Build all packages and add them to the repo
    dryrun                  - Pretend to build all packages
    listpkgs                - List all packages
EOF
    exit 1
fi

if [ "$1" = "pkgall" ]; then
    buildall
    "$_FIND" . -iname "*.deb" -exec cp {} "$_REPODIR/debs" \;
    "$_REPODIR/update.sh"
elif [ "$1" = "all" ]; then
    buildall
elif [ "$1" = "listpkgs" ]; then
    for pkg in "$_PKGDIR"/*; do
        printf "%s\n" "${pkg##*/}"
    done
elif [ "$1" = "pkg" ]; then
    build "$2" "$3"
    "$_FIND" "$_PKGDIR/$2" -iname "*.deb" -exec cp {} "$_REPODIR/debs" \;
    "$_REPODIR/update.sh"
elif [ -d "$_PKGDIR/$1" ]; then
    build "$@"
elif [ "$1" = dryrun ]; then
    buildall dryrun
else
    printf "ERROR: Package %s not found!\n" "$1"
    exit 1
fi
