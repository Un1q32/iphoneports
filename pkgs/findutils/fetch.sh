#!/bin/sh
rm -rf pkg src
ver='4.10.0'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/findutils-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/findutils-$ver.tar.xz" | awk '{print $1}')" != "1387e0b67ff247d2abde998f90dfbf70c1491391a59ddfecb8ae698789f0a4f5" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/findutils-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/findutils/findutils-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/findutils-$ver.tar.xz"
mv findutils-* src
