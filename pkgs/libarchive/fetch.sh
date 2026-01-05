#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.8.5'
if [ ! -f "$_DLCACHE/libarchive-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libarchive-$ver.tar.xz" | awk '{print $1}')" != "d68068e74beee3a0ec0dd04aee9037d5757fcc651591a6dcf1b6d542fb15a703" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libarchive-$ver.tar.xz" "https://www.libarchive.org/downloads/libarchive-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libarchive-$ver.tar.xz"
mv "$_TMP"/libarchive-* "$_SRCDIR"
