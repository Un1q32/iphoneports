#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.9.1'
if [ ! -f "$_DLCACHE/wasm3-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wasm3-$ver.tar.gz" | awk '{print $1}')" != "50a6b26b46648f037d58ba5ed7f1d1c48b67506cbb12e1fbe222e6c1b64a6a6e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wasm3-$ver.tar.gz" "https://github.com/wasm3/wasm3/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/wasm3-$ver.tar.gz"
mv "$_TMP"/wasm3-* "$_SRCDIR"
