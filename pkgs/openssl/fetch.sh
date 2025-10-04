#!/bin/sh
rm -rf pkg src
ver='3.5.4'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/openssl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssl-$ver.tar.gz" | awk '{print $1}')" != "967311f84955316969bdb1d8d4b983718ef42338639c621ec4c34fddef355e99" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssl-$ver.tar.gz" "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz"
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/openssl-$ver.tar.gz"
mv openssl-* src
