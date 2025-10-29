#!/bin/sh
rm -rf pkg src
ver='54bba26c004452fec5cca71dfbb7a703dc088364'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "18e91a1d1882ef9c1bf85865175bbd9262c5857d0151f1ac783e984e3b4b723f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv cctools-port-* src
