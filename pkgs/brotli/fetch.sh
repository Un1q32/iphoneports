#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.2.0'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/brotli-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/brotli-$ver.tar.gz" | awk '{print $1}')" != "816c96e8e8f193b40151dad7e8ff37b1221d019dbcb9c35cd3fadbfe6477dfec" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/brotli-$ver.tar.gz" "https://github.com/google/brotli/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/brotli-$ver.tar.gz"
mv brotli-* "$_SRCDIR"
