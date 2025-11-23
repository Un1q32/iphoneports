#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.6.51'
if [ ! -f "$_DLCACHE/libpng-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpng-$ver.tar.xz" | awk '{print $1}')" != "a050a892d3b4a7bb010c3a95c7301e49656d72a64f1fc709a90b8aded192bed2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpng-$ver.tar.xz" "https://download.sourceforge.net/libpng/libpng-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpng-$ver.tar.xz"
mv "$_TMP"/libpng-* "$_SRCDIR"
