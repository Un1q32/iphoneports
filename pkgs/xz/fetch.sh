#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.8.3'
if [ ! -f "$_DLCACHE/xz-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/xz-$ver.tar.xz" | awk '{print $1}')" != "fff1ffcf2b0da84d308a14de513a1aa23d4e9aa3464d17e64b9714bfdd0bbfb6" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/xz-$ver.tar.xz" "https://github.com/tukaani-project/xz/releases/download/v$ver/xz-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/xz-$ver.tar.xz"
mv "$_TMP"/xz-* "$_SRCDIR"
