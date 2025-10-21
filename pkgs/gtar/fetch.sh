#!/bin/sh
rm -rf pkg src
ver='1.35'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/gtar-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/gtar-$ver.tar.xz" | awk '{print $1}')" != "4d62ff37342ec7aed748535323930c7cf94acf71c3591882b26a7ea50f3edc16" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gtar-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/tar/tar-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/gtar-$ver.tar.xz"
mv tar-* src
