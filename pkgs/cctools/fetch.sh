#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='961fe37b068bd635aee1ad20d4ab1d410216c2e5'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "128d493f86d51581fa8850055847a27c98468d7b94d7a3592b940e8c0c180c12" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv cctools-port-* "$_SRCDIR"
