#!/bin/sh
rm -rf pkg src
ver='4.1.1'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/libressl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libressl-$ver.tar.gz" | awk '{print $1}')" != "c7ff7a7d675d5f57730940e5ccff1dbe2dcd5b7405b5397e0f7ffd66a5ed5679" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libressl-$ver.tar.gz" "https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/libressl-$ver.tar.gz"
mv libressl-* src
