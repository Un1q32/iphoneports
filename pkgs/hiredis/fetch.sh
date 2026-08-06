#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.4.1'
if [ ! -f "$_DLCACHE/hiredis-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/hiredis-$ver.tar.gz" | awk '{print $1}')" != "ca3180359a8b1275838a45415851f8cd5c411e27bdbf18f4823012e45507d2e4" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/hiredis-$ver.tar.gz" "https://github.com/redis/hiredis/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/hiredis-$ver.tar.gz"
mv "$_TMP"/hiredis-* "$_SRCDIR"
