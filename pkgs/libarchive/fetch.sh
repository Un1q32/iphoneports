#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.8.3'
if [ ! -f "$_DLCACHE/libarchive-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libarchive-$ver.tar.xz" | awk '{print $1}')" != "90e21f2b89f19391ce7b90f6e48ed9fde5394d23ad30ae256fb8236b38b99788" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libarchive-$ver.tar.xz" "https://www.libarchive.org/downloads/libarchive-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libarchive-$ver.tar.xz"
mv "$_TMP"/libarchive-* "$_SRCDIR"
