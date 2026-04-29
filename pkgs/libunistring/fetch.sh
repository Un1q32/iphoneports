#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.3'
if [ ! -f "$_DLCACHE/libunistring-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libunistring-$ver.tar.gz" | awk '{print $1}')" != "8ea8ccf86c09dd801c8cac19878e804e54f707cf69884371130d20bde68386b7" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libunistring-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/libunistring/libunistring-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libunistring-$ver.tar.gz"
mv "$_TMP"/libunistring-* "$_SRCDIR"
