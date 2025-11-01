#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='6.3.0'
if [ ! -f "$_DLCACHE/gmp-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/gmp-$ver.tar.xz" | awk '{print $1}')" != "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gmp-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/gmp/gmp-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/gmp-$ver.tar.xz"
mv gmp-* "$_SRCDIR"
