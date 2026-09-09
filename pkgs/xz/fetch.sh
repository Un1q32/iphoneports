#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.8.4'
if [ ! -f "$_DLCACHE/xz-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/xz-$ver.tar.xz" | awk '{print $1}')" != "4ce24038fd4221e0d13bc1a2de7a4db56e90b92b3bf75321f6c14be73f65de4b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/xz-$ver.tar.xz" "https://github.com/tukaani-project/xz/releases/download/v$ver/xz-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/xz-$ver.tar.xz"
mv "$_TMP"/xz-* "$_SRCDIR"
