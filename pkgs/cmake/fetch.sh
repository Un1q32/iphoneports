#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.4.0'
if [ ! -f "$_DLCACHE/cmake-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cmake-$ver.tar.gz" | awk '{print $1}')" != "0dc194a6ade7d0ec474f952dcc923aa43d72eef971b64fb9813f78e6c4e61afc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cmake-$ver.tar.gz" "https://github.com/Kitware/CMake/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cmake-$ver.tar.gz"
mv "$_TMP"/CMake-* "$_SRCDIR"
