#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.9.0'
if [ ! -f "$_DLCACHE/wasm3-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wasm3-$ver.tar.gz" | awk '{print $1}')" != "cab79ce74bcac25bbf80b5ebe14af9795b9bac30b05ee8f620a3bc8002f3b8e6" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wasm3-$ver.tar.gz" "https://github.com/wasm3/wasm3/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/wasm3-$ver.tar.gz"
mv "$_TMP"/wasm3-* "$_SRCDIR"
