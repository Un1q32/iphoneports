#!/bin/sh
_TARGET="arm-apple-darwin9"
_SDK="$HOME/iosdev/toolchain/sdk"
_REPODIR="$HOME/iosdev/oldworldordr.github.io"
_PKGDIR="${0%/*}/pkgs"
_PKGDIR="$(cd "$_PKGDIR" && pwd)"
_BSROOT="$_PKGDIR/.."
_ENTITLEMENTS="$_BSROOT/entitlements.plist"
export _PKGDIR _BSROOT _REPODIR _SDK _TARGET _ENTITLEMENTS
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
                export _SDKPATH="$_BSROOT/sdk"
                rm -rf "$_SDKPATH"
                cp -r "$_SDK" "$_SDKPATH"
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
    rm -rf "$_SDKPATH"
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

for dep in "$_TARGET-clang" "$_TARGET-clang++" "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" curl ldid make patch dpkg-deb; do
    if ! command -v "$dep" > /dev/null; then
        printf "Missing dependency %s\n" "$dep"
        exit 1
    fi
done

if "$_TARGET"-strip --version 2> /dev/null | grep -q "GNU"; then
    printf "ERROR: GNU/LLVM strip is not supported!\n"
    exit 1
fi

if [ -z "$1" ]; then
    cat << EOF
Usage: build.sh <pkg|all|pkgall|listpkgs>
Usage: build.sh <package name>
    <package name>          - Build a single package
    pkg <package name>      - Build a single package and add it to the repo
    all                     - Build all packages
    pkgall                  - Build all packages and add them to the repo
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
else
    printf "ERROR: Package %s not found!\n" "$1"
    exit 1
fi
