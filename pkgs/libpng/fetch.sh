#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.6.57'
if [ ! -f "$_DLCACHE/libpng-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpng-$ver.tar.xz" | awk '{print $1}')" != "d10c20d7171569804cae8dfc13ba6dcd0662c41ed39d43d4d429314aafb10a80" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpng-$ver.tar.xz" "https://download.sourceforge.net/libpng/libpng-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpng-$ver.tar.xz"
mv "$_TMP"/libpng-* "$_SRCDIR"
