#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.8.7'
if [ ! -f "$_DLCACHE/libarchive-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libarchive-$ver.tar.xz" | awk '{print $1}')" != "d3a8ba457ae25c27c84fd2830a2efdcc5b1d40bf585d4eb0d35f47e99e5d4774" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libarchive-$ver.tar.xz" "https://www.libarchive.org/downloads/libarchive-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libarchive-$ver.tar.xz"
mv "$_TMP"/libarchive-* "$_SRCDIR"
