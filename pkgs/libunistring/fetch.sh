#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.4.2'
if [ ! -f "$_DLCACHE/libunistring-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libunistring-$ver.tar.xz" | awk '{print $1}')" != "5b46e74377ed7409c5b75e7a96f95377b095623b689d8522620927964a41499c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libunistring-$ver.tar.xz" "https://ftp.gnu.org/gnu/libunistring/libunistring-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libunistring-$ver.tar.xz"
mv "$_TMP"/libunistring-* "$_SRCDIR"
