#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.4.4'
if [ ! -f "$_DLCACHE/wamr-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wamr-$ver.tar.gz" | awk '{print $1}')" != "03ad51037f06235577b765ee042a462326d8919300107af4546719c35525b298" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wamr-$ver.tar.gz" "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/wamr-$ver.tar.gz"
mv "$_TMP"/wasm-micro-runtime-WAMR-* "$_SRCDIR"
