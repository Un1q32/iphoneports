#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.48.0'
if [ ! -f "$_DLCACHE/libuv-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libuv-$ver.tar.gz" | awk '{print $1}')" != "8c253adb0f800926a6cbd1c6576abae0bc8eb86a4f891049b72f9e5b7dc58f33" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libuv-$ver.tar.gz" "https://github.com/libuv/libuv/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libuv-$ver.tar.gz"
mv "$_TMP"/libuv-* "$_SRCDIR"
