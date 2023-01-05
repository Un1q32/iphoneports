#!/bin/sh
repodir=/home/joey/iosdev/oldworldordr.github.io
pkgdir="${0%/*}/pkgs"
pkgdir="$(cd "$pkgdir" && pwd)"
export TERM=xterm-256color
printf "\n" > /tmp/.builtpkgs

hasbeenbuilt() {
    while read -r pkg; do
        if [ "$pkg" = "$1" ] && { [ -d "$pkgdir/$pkg/package/usr/include" ] || [ -d "$pkgdir/$pkg/package/usr/lib" ]; }; then
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
    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$pkgdir/$dep" ]; then
                if [ "$1" = "-r" ] && ! hasbeenbuilt "$dep"; then
                    printf "Building dependency %s\n" "$dep"
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
    cd "$pkgdir/$1" || exit 1
    includedeps "$2"
    ./fetch.sh
    applypatches
    ./build.sh
    )
}

buildall() {
    for pkg in "$pkgdir"/*; do
        pkg="${pkg##*/}"
        build "$pkg" -r || { printf "Failed to build %s\n" "$pkg"; exit 1; }
        printf "%s\n" "$pkg" >> /tmp/.builtpkgs
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
    for pkg in "$pkgdir"/*; do
        printf "%s\n" "${pkg##*/}"
    done
elif [ "$1" = "pkg" ]; then
    build "$2" "$3"
    find "$pkgdir/$2" -iname "*.deb" -exec cp {} "$repodir/debs" \;
    "$repodir/update.sh"
elif [ -d "$pkgdir/$1" ]; then
    build "$@"
else
    printf "ERROR: Package %s not found!\n" "$1"
    exit 1
fi
