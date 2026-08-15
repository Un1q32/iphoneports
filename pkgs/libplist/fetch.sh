#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.7.0'
if [ ! -f "$_DLCACHE/libplist-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/libplist-$ver.tar.bz2" | awk '{print $1}')" != "7ac42301e896b1ebe3c654634780c82baa7cb70df8554e683ff89f7c2643eb8b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libplist-$ver.tar.bz2" "https://github.com/libimobiledevice/libplist/releases/download/$ver/libplist-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libplist-$ver.tar.bz2"
mv "$_TMP"/libplist-* "$_SRCDIR"
