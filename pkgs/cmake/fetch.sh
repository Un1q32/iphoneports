#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.3.0'
if [ ! -f "$_DLCACHE/cmake-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cmake-$ver.tar.gz" | awk '{print $1}')" != "4e8cc897c348afe213004af2cda5589272f6ee9408199c5bfe200bfe9ad43326" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cmake-$ver.tar.gz" "https://github.com/Kitware/CMake/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cmake-$ver.tar.gz"
mv "$_TMP"/CMake-* "$_SRCDIR"
