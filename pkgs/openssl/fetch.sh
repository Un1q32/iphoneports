#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.6.4'
if [ ! -f "$_DLCACHE/openssl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssl-$ver.tar.gz" | awk '{print $1}')" != "9bffaa1ad1e07b354c21bd3324ec02fa15579f45a7d0494b3e74bc449b7333ef" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssl-$ver.tar.gz" "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/openssl-$ver.tar.gz"
mv "$_TMP"/openssl-* "$_SRCDIR"
