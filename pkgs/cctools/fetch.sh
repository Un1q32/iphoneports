#!/bin/sh
rm -rf pkg src
ver='fa35d815d3cd7abaeaf43db4044a700cafdd9cf2'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "ac1194ea90e2dbe0b7e0a7a77537e6df5dd0f5fc4745eca4c20d0baed3885c88" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv cctools-port-* src
