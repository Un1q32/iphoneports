#!/bin/sh
rm -rf pkg src
ver='4.2.0'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/libressl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libressl-$ver.tar.gz" | awk '{print $1}')" != "0f7dba44d7cb8df8d53f2cfbf1955254bc128e0089595f1aba2facfaee8408b2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libressl-$ver.tar.gz" "https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/libressl-$ver.tar.gz"
mv libressl-* src
