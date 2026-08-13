#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.12.2'
if [ ! -f "$_DLCACHE/libgcrypt-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libgcrypt-$ver.tar.gz" | awk '{print $1}')" != "3506339b02adb6148fa2365a4e748f3d30fcc351b8c443897cd0d6fbcd4cfaf8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgcrypt-$ver.tar.gz" "https://github.com/gpg/libgcrypt/archive/refs/tags/libgcrypt-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libgcrypt-$ver.tar.gz"
mv "$_TMP"/libgcrypt-* "$_SRCDIR"
