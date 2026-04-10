#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3530000'
if [ ! -f "$_DLCACHE/sqlite-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/sqlite-$ver.tar.gz" | awk '{print $1}')" != "851e9b38192fe2ceaa65e0baa665e7fa06230c3d9bd1a6a9662d02380d73365a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/sqlite-$ver.tar.gz" "https://sqlite.org/2026/sqlite-autoconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/sqlite-$ver.tar.gz"
mv "$_TMP"/sqlite-* "$_SRCDIR"
