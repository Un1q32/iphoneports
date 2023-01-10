#!/bin/sh
case "$*" in
    *--target=*)
        _args="$*"
        _TARGET="${_args#*--target=}"
        ;;
    *)
        _TARGET="arm-apple-darwin9"
        ;;
esac
if command -v "$_TARGET-sdkpath" > /dev/null; then
    _SDK="$("$_TARGET-sdkpath")"
else
    printf "ERROR: Missing dependency: %s-sdkpath\n" "$_TARGET"
    exit 1
fi
_REPODIR="$HOME/iosdev/oldworldordr.github.io"
_BSROOT="${0%/*}"
_BSROOT="$(cd "$_BSROOT" && pwd)"
_PKGDIR="$_BSROOT/pkgs"
export _PKGDIR _BSROOT _REPODIR _SDK _TARGET
export TERM="xterm-256color"
printf "" > /tmp/.builtpkgs

hasbeenbuilt() {
    while read -r pkg; do
        if [ "$pkg" = "$1" ] && { [ "$2" = "dryrun" ] || [ -d "$_PKGDIR/$1/package/usr/include" ] || [ -d "$_PKGDIR/$1/package/usr/lib" ]; }; then
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
        rm -rf "$_SDKPATH"
        cp -r "$_SDK" "$_BSROOT"
        while read -r dep; do
            if [ -d "$_PKGDIR/$dep" ]; then
                if [ "$1" = "-r" ] && ! hasbeenbuilt "$dep" "$2"; then
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
    hasbeenbuilt "$1" "$3" && return 0
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

for dep in "$_TARGET-clang" "$_TARGET-clang++" "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" ldid patch dpkg-deb; do
    if ! command -v "$dep" > /dev/null; then
        printf "ERROR: Missing dependency %s\n" "$dep"
        exit 1
    fi
done

if "$_TARGET"-strip --version 2> /dev/null | grep -q "GNU"; then
    printf "ERROR: GNU/LLVM strip is not supported!\n"
    exit 1
fi

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
    find . -iname "*.deb" -exec cp {} "$_REPODIR/debs" \;
    "$_REPODIR/update.sh"
elif [ "$1" = "all" ]; then
    buildall
elif [ "$1" = "listpkgs" ]; then
    for pkg in "$_PKGDIR"/*; do
        printf "%s\n" "${pkg##*/}"
    done
elif [ "$1" = "pkg" ]; then
    build "$2" "$3"
    find "$_PKGDIR/$2" -iname "*.deb" -exec cp {} "$_REPODIR/debs" \;
    "$_REPODIR/update.sh"
elif [ -d "$_PKGDIR/$1" ]; then
    build "$@"
elif [ "$1" = dryrun ]; then
    buildall dryrun
else
    printf "ERROR: Package %s not found!\n" "$1"
    exit 1
fi
