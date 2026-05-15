#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3530100'
if [ ! -f "$_DLCACHE/sqlite-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/sqlite-$ver.tar.gz" | awk '{print $1}')" != "83e6b2020a034e9a7ad4a72feea59e1ad52f162e09cbd26735a3ffb98359fc4f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/sqlite-$ver.tar.gz" "https://sqlite.org/2026/sqlite-autoconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/sqlite-$ver.tar.gz"
mv "$_TMP"/sqlite-* "$_SRCDIR"
