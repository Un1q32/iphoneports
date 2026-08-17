#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.23.3'
if [ ! -f "$_DLCACHE/libpsl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpsl-$ver.tar.gz" | awk '{print $1}')" != "93941f85a1e7bd593fa94f299233cb5dfc91cd144fd9a78a6ceb75001c5b03be" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpsl-$ver.tar.gz" "https://github.com/rockdaboot/libpsl/releases/download/$ver/libpsl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpsl-$ver.tar.gz"
mv "$_TMP"/libpsl-* "$_SRCDIR"
