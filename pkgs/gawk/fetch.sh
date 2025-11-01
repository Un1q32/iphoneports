#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.3.2'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/gawk-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/gawk-$ver.tar.xz" | awk '{print $1}')" != "f8c3486509de705192138b00ef2c00bbbdd0e84c30d5c07d23fc73a9dc4cc9cc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gawk-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/gawk/gawk-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/gawk-$ver.tar.xz"
mv gawk-* "$_SRCDIR"
