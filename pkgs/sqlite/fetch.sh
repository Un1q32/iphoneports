#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3520000'
if [ ! -f "$_DLCACHE/sqlite-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/sqlite-$ver.tar.gz" | awk '{print $1}')" != "f6b50b0c103392af32a8be15b2b9d25959de9a00a70c3979128aafeaa5338b3f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/sqlite-$ver.tar.gz" "https://sqlite.org/2026/sqlite-autoconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/sqlite-$ver.tar.gz"
mv "$_TMP"/sqlite-* "$_SRCDIR"
