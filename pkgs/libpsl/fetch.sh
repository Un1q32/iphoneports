#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.23.0'
if [ ! -f "$_DLCACHE/libpsl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpsl-$ver.tar.gz" | awk '{print $1}')" != "f39b9631b3d369a21259ea4654f8875c0ec6995ce9551c0eb5d423e4c011f911" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpsl-$ver.tar.gz" "https://github.com/rockdaboot/libpsl/releases/download/$ver/libpsl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpsl-$ver.tar.gz"
mv "$_TMP"/libpsl-* "$_SRCDIR"
