#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.8.6'
if [ ! -f "$_DLCACHE/libarchive-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libarchive-$ver.tar.xz" | awk '{print $1}')" != "8ac57c1f5e99550948d1fe755c806d26026e71827da228f36bef24527e372e6f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libarchive-$ver.tar.xz" "https://www.libarchive.org/downloads/libarchive-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libarchive-$ver.tar.xz"
mv "$_TMP"/libarchive-* "$_SRCDIR"
