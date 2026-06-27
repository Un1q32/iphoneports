#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3530300'
if [ ! -f "$_DLCACHE/sqlite-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/sqlite-$ver.tar.gz" | awk '{print $1}')" != "c917d7db16648ec95f714974ace5e5dcf46b7dc70e26600a0a102a3141125db0" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/sqlite-$ver.tar.gz" "https://sqlite.org/2026/sqlite-autoconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/sqlite-$ver.tar.gz"
mv "$_TMP"/sqlite-* "$_SRCDIR"
