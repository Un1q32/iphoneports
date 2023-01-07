#!/bin/sh
export _TARGET="arm-apple-darwin9"
export _SDK="$HOME/iosdev/toolchain/sdk"
repodir="$HOME/iosdev/oldworldordr.github.io"
_PKGDIR="${0%/*}/pkgs"
_PKGDIR="$(cd "$_PKGDIR" && pwd)"
_BSROOT="$_PKGDIR/.."
export _PKGDIR _BSROOT
export TERM=xterm-256color
printf "\n" > /tmp/.builtpkgs

hasbeenbuilt() {
    while read -r pkg; do
        if [ "$pkg" = "$1" ] && { [ -d "$_PKGDIR/$pkg/package/usr/include" ] || [ -d "$_PKGDIR/$pkg/package/usr/lib" ]; }; then
            return=0
        else
            return=1
        fi
    done < /tmp/.builtpkgs

    if [ "$return" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

applypatches() {
    if [ -d patches ]; then
        for patch in patches/*.patch; do
            printf "Applying patch %s\n" "${patch##*/}"
            patch -p1 < "$patch"
        done
    fi
}

includedeps() {
    cp -r "$_SDK" "$_BSROOT/sdk"
    export _SDKPATH="$_BSROOT/sdk"
    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$_PKGDIR/$dep" ]; then
                if [ "$1" = "-r" ] && ! hasbeenbuilt "$dep"; then
                    printf "Building dependency %s\n" "$dep"
                    build "$dep"
                    [ -d "$_PKGDIR/$dep/package/usr/include" ] || [ -d "$_PKGDIR/$dep/package/usr/lib" ] || { printf "Failed to build dependency %s\n" "$dep"; rm /tmp/.builtpkgs; exit 1; }
                    printf "%s\n" "$dep" >> /tmp/.builtpkgs
                fi
                printf "Including dependency %s\n" "$dep"
                cp -r "$_PKGDIR/$dep/package/usr/include" "$_SDKPATH/usr/include"
                cp -r "$_PKGDIR/$dep/package/usr/lib" "$_SDKPATH/usr/lib"
            fi
        done < dependencies.txt
    fi
}

build() {
    (
    printf "Building %s...\n" "${1##*/}"
    cd "$_PKGDIR/$1" || exit 1
    includedeps "$2"
    ./fetch.sh
    applypatches
    ./build.sh
    rm -rf "$_BSROOT/sdk"
    )
}

buildall() {
    for pkg in "$_PKGDIR"/*; do
        pkg="${pkg##*/}"
        build "$pkg" -r || { printf "Failed to build %s\n" "$pkg"; exit 1; }
        printf "%s\n" "$pkg" >> /tmp/.builtpkgs
    done
    rm /tmp/.builtpkgs
}

if command -v "$_TARGET"-clang > /dev/null; then
    _CC="$_TARGET"-clang
elif command -v "$_TARGET"-gcc > /dev/null; then
    _CC="$_TARGET"-gcc
elif command -v "$_TARGET"-cc > /dev/null; then
    _CC="$_TARGET"-cc
else
    printf "ERROR: No valid C compiler found!\n"
    exit 1
fi

if command -v "$_TARGET"-clang++ > /dev/null; then
    _CXX="$_TARGET"-clang++
elif command -v "$_TARGET"-g++ > /dev/null; then
    _CXX="$_TARGET"-g++
elif command -v "$_TARGET"-c++ > /dev/null; then
    _CXX="$_TARGET"-c++
else
    printf "ERROR: No valid C++ compiler found!\n"
    exit 1
fi

if command -v "$_TARGET"-strip > /dev/null; then
    if "$_TARGET"-strip --version 2> /dev/null | grep -q "GNU"; then
        printf "ERROR: GNU/LLVM strip is not supported!\n"
        exit 1
    else
        _STRIP="$_TARGET"-strip
    fi
else
    printf "ERROR: No valid strip command found!\n"
    exit 1
fi

if ! command -v ldid > /dev/null; then
    printf "ERROR: ldid not found!\n"
elif ! command -v dpkg-deb > /dev/null; then
    printf "ERROR: dpkg-deb not found!\n"
fi

export _CC _CXX _STRIP _TARGET

if [ -z "$1" ]; then
    cat << EOF
Usage: build.sh <pkg|all|pkgall|listpkgs>
Usage: build.sh <package name>
    <package name>      - Build a single package
    pkg <package name>  - Build a single package and add it to the repo
    all                 - Build all packages
    pkgall              - Build all packages and add them to the repo
    listpkgs            - List all packages
EOF
    exit 1
fi

if [ "$1" = "pkgall" ]; then
    buildall
    find . -iname "*.deb" -exec cp {} "$repodir/debs" \;
    "$repodir/update.sh"
elif [ "$1" = "all" ]; then
    buildall
elif [ "$1" = "listpkgs" ]; then
    for pkg in "$_PKGDIR"/*; do
        printf "%s\n" "${pkg##*/}"
    done
elif [ "$1" = "pkg" ]; then
    build "$2" "$3"
    find "$_PKGDIR/$2" -iname "*.deb" -exec cp {} "$repodir/debs" \;
    "$repodir/update.sh"
elif [ -d "$_PKGDIR/$1" ]; then
    build "$@"
else
    printf "ERROR: Package %s not found!\n" "$1"
    exit 1
fi
