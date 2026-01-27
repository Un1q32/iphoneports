#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.6.1'
if [ ! -f "$_DLCACHE/openssl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssl-$ver.tar.gz" | awk '{print $1}')" != "b1bfedcd5b289ff22aee87c9d600f515767ebf45f77168cb6d64f231f518a82e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssl-$ver.tar.gz" "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/openssl-$ver.tar.gz"
mv "$_TMP"/openssl-* "$_SRCDIR"
