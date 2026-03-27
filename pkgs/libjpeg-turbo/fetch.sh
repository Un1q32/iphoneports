#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.1.4.1'
if [ ! -f "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" | awk '{print $1}')" != "a7da42b640377c2a9a9665e2c4b0ea60cd5599afb48c2521e6df0c9dc9d15a25" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libjpeg-turbo-$ver.tar.gz"
mv "$_TMP"/libjpeg-turbo-* "$_SRCDIR"
