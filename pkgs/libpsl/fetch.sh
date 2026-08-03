#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.23.1'
if [ ! -f "$_DLCACHE/libpsl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpsl-$ver.tar.gz" | awk '{print $1}')" != "8fbb03054556498ba9c4cc48fcaa36a4483748c6504a65bdb9ba348f555b0e56" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpsl-$ver.tar.gz" "https://github.com/rockdaboot/libpsl/releases/download/$ver/libpsl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpsl-$ver.tar.gz"
mv "$_TMP"/libpsl-* "$_SRCDIR"
