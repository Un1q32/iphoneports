#!/bin/sh
repodir=/home/joey/iosdev/oldworldordr.github.io
pkgdir="${0%/*}/pkgs"
pkgdir="$(cd "$pkgdir" && pwd)"

hasbeenbuilt() {
    while read -r pkg; do
        if [ "$pkg" = "$1" ]; then
            if [ -d "$pkgdir/$pkg/package/usr/include" ] || [ -d "$pkgdir/$pkg/package/usr/lib" ]; then
                return 0
            else
                return 1
            fi
        fi
    done < /tmp/.builtpkgs
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
    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$pkgdir/$dep" ]; then
                if [ "$1" = "-r" ] && ! hasbeenbuilt "$dep"; then
                    printf "Building dependency %s\n" "$dep"
                    cd "$pkgdir" || exit 1
                    build "$dep"
                    printf "%s\n" "$dep" >> /tmp/.builtpkgs
                fi
                printf "Including dependency %s\n" "$dep"
                export CFLAGS="$CFLAGS -I$pkgdir/$dep/package/usr/include"
                export LDFLAGS="$LDFLAGS -L$pkgdir/$dep/package/usr/lib"
            fi
        done < dependencies.txt
    fi
}

build() {
    (
    printf "Building %s...\n" "${1##*/}"
    cd "$1" || exit 1
    ./fetch.sh
    applypatches
    includedeps "$2"
    ./build.sh
    )
}

buildall() {
    for pkg in "$pkgdir"/*; do
        build "$pkg" "$1"
        printf "%s\n" "${pkg##*/}" >> /tmp/.builtpkgs
    done
    rm /tmp/.builtpkgs
}

if command -v arm-apple-darwin9-clang > /dev/null; then
    _CC=arm-apple-darwin9-clang
elif command -v arm-apple-darwin9-gcc > /dev/null; then
    _CC=arm-apple-darwin9-gcc
elif command -v arm-apple-darwin9-cc > /dev/null; then
    _CC=arm-apple-darwin9-cc
else
    printf "ERROR: No valid C compiler found!\n"
    exit 1
fi

if command -v arm-apple-darwin9-clang++ > /dev/null; then
    _CXX=arm-apple-darwin9-clang++
elif command -v arm-apple-darwin9-g++ > /dev/null; then
    _CXX=arm-apple-darwin9-g++
elif command -v arm-apple-darwin9-c++ > /dev/null; then
    _CXX=arm-apple-darwin9-c++
else
    printf "ERROR: No valid C++ compiler found!\n"
    exit 1
fi

if command -v arm-apple-darwin9-strip > /dev/null; then
    if arm-apple-darwin9-strip --version 2> /dev/null | grep -q "GNU"; then
        printf "ERROR: GNU/LLVM strip is not supported!\n"
        exit 1
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

export _CC _CXX

if [ -z "$1" ]; then
    printf "Usage: %s <all|pkgall|listpkgs|package>\n" "${0##*/}"
    exit 1
fi

cd "$pkgdir" || exit 1

if [ "$1" = "pkgall" ]; then
    buildall "$2"
    find . -iname "*.deb" -exec cp {} "$repodir/debs" \;
    "$repodir/update.sh"
elif [ "$1" = "all" ]; then
    buildall "$2"
elif [ "$1" = "listpkgs" ]; then
    for pkg in "$pkgdir"/*; do
        printf "%s\n" "${pkg##*/}"
    done
elif [ "$1" = "pkg" ]; then
    build "$2" "$3"
    cp "$1/*.deb" "$repodir/debs"
    "$repodir/update.sh"
elif [ -d "$1" ]; then
    build "$@"
else
    printf "ERROR: Package %s not found!\n" "$1"
    exit 1
fi
