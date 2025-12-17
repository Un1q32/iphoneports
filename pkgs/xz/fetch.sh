#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.8.2'
if [ ! -f "$_DLCACHE/xz-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/xz-$ver.tar.xz" | awk '{print $1}')" != "890966ec3f5d5cc151077879e157c0593500a522f413ac50ba26d22a9a145214" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/xz-$ver.tar.xz" "https://github.com/tukaani-project/xz/releases/download/v$ver/xz-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/xz-$ver.tar.xz"
mv "$_TMP"/xz-* "$_SRCDIR"
