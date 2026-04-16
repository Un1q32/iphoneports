#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.22.1'
if [ ! -f "$_DLCACHE/ngtcp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ngtcp2-$ver.tar.xz" | awk '{print $1}')" != "dfd2c68bd64b89847c611425b9487105c46e8447b5c21e6aeb00642c8fbe2ca8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ngtcp2-$ver.tar.xz" "https://github.com/ngtcp2/ngtcp2/releases/download/v$ver/ngtcp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ngtcp2-$ver.tar.xz"
mv "$_TMP"/ngtcp2-* "$_SRCDIR"
