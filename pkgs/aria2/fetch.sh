#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.37.0'
if [ ! -f "$_DLCACHE/aria2-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/aria2-$ver.tar.gz" | awk '{print $1}')" != "9104878396cc30441976afdd3af9331ec51306fabf92fb82724c3b8fa7d72932" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/aria2-$ver.tar.gz" "https://github.com/aria2/aria2/archive/refs/tags/release-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/aria2-$ver.tar.gz"
mv "$_TMP"/aria2-* "$_SRCDIR"
