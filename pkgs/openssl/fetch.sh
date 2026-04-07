#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.6.2'
if [ ! -f "$_DLCACHE/openssl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssl-$ver.tar.gz" | awk '{print $1}')" != "aaf51a1fe064384f811daeaeb4ec4dce7340ec8bd893027eee676af31e83a04f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssl-$ver.tar.gz" "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/openssl-$ver.tar.gz"
mv "$_TMP"/openssl-* "$_SRCDIR"
