#!/bin/sh
rm -rf pkg src
ver='3.8.2'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/libarchive-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libarchive-$ver.tar.xz" | awk '{print $1}')" != "db0dee91561cbd957689036a3a71281efefd131d35d1d98ebbc32720e4da58e2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libarchive-$ver.tar.xz" "https://www.libarchive.org/downloads/libarchive-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/libarchive-$ver.tar.xz"
mv libarchive-* src
