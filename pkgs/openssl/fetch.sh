#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.6.3'
if [ ! -f "$_DLCACHE/openssl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssl-$ver.tar.gz" | awk '{print $1}')" != "243a86649cf6f23eeb6a2ff2456e09e5d77dd9018a54d3d96b0c6bdd6ba6c7f1" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssl-$ver.tar.gz" "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/openssl-$ver.tar.gz"
mv "$_TMP"/openssl-* "$_SRCDIR"
