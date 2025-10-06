#!/bin/sh
rm -rf pkg src
ver='4.1.2'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/cmake-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cmake-$ver.tar.gz" | awk '{print $1}')" != "ccf48cd50c3441c5eee23351ffbf1264bc246e2ce94c953e4440747d7b74877e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cmake-$ver.tar.gz" "https://github.com/Kitware/CMake/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/cmake-$ver.tar.gz"
mv CMake-* src
