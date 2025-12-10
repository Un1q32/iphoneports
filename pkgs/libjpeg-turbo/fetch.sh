#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.1.3'
if [ ! -f "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" | awk '{print $1}')" != "3a13a5ba767dc8264bc40b185e41368a80d5d5f945944d1dbaa4b2fb0099f4e5" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libjpeg-turbo-$ver.tar.gz"
mv "$_TMP"/libjpeg-turbo-* "$_SRCDIR"
