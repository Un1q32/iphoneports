#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.6.0'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/openssl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssl-$ver.tar.gz" | awk '{print $1}')" != "b6a5f44b7eb69e3fa35dbf15524405b44837a481d43d81daddde3ff21fcbb8e9" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssl-$ver.tar.gz" "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/openssl-$ver.tar.gz"
mv openssl-* "$_SRCDIR"
