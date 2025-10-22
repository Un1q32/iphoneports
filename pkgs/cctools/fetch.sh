#!/bin/sh
rm -rf pkg src
ver='38fcee34eb502c63482dba1a1b3246bf2f051fdb'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "6e56188f5ada0e12f9464eb08fb93abd16943536390025d5ac3506207b0ab750" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv cctools-port-* src
