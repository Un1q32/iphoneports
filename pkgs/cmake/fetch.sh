#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.3.1'
if [ ! -f "$_DLCACHE/cmake-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cmake-$ver.tar.gz" | awk '{print $1}')" != "d602411de1cfeee3bdeea2e6722cf0b47e740280503b70d15e3c99812904beea" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cmake-$ver.tar.gz" "https://github.com/Kitware/CMake/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cmake-$ver.tar.gz"
mv "$_TMP"/CMake-* "$_SRCDIR"
