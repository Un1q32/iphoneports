#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.5.4'
if [ ! -f "$_DLCACHE/bzip3-$ver.tar.zst" ] ||
    [ "$(sha256sum "$_DLCACHE/bzip3-$ver.tar.zst" | awk '{print $1}')" != "b9a5898d1c027802bea044e97ccaa141dd7e5a3261dd65b1a49e0df82cbf172a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/bzip3-$ver.tar.zst" "https://github.com/kspalaiologos/bzip3/releases/download/$ver/bzip3-$ver.tar.zst" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/bzip3-$ver.tar.zst"
mv "$_TMP"/bzip3-* "$_SRCDIR"
