#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.22.0'
if [ ! -f "$_DLCACHE/libpsl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpsl-$ver.tar.gz" | awk '{print $1}')" != "c45c3aa17576b99873e05a9b09a44041b065bbfa390e6d474d06fbfaeb9c7722" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpsl-$ver.tar.gz" "https://github.com/rockdaboot/libpsl/releases/download/$ver/libpsl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpsl-$ver.tar.gz"
mv "$_TMP"/libpsl-* "$_SRCDIR"
