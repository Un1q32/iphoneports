#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.21.5'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/libpsl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpsl-$ver.tar.gz" | awk '{print $1}')" != "1dcc9ceae8b128f3c0b3f654decd0e1e891afc6ff81098f227ef260449dae208" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpsl-$ver.tar.gz" "https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/libpsl-$ver.tar.gz"
mv libpsl-* "$_SRCDIR"
