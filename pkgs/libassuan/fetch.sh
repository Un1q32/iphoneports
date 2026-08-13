#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.0.2'
if [ ! -f "$_DLCACHE/libassuan-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libassuan-$ver.tar.gz" | awk '{print $1}')" != "dfd4e6b85de83c7b8096c6d79b914501611f56a21c3db92f63352030d21e3d6f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libassuan-$ver.tar.gz" "https://github.com/gpg/libassuan/archive/refs/tags/libassuan-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libassuan-$ver.tar.gz"
mv "$_TMP"/libassuan-* "$_SRCDIR"
