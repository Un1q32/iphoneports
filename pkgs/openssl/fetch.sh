#!/bin/sh
rm -rf pkg src
ver='3.5.2'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/openssl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssl-$ver.tar.gz" | awk '{print $1}')" != "c53a47e5e441c930c3928cf7bf6fb00e5d129b630e0aa873b08258656e7345ec" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssl-$ver.tar.gz" "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz"
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/openssl-$ver.tar.gz"
mv openssl-* src
