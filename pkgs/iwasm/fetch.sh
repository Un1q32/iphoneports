#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.4.5'
if [ ! -f "$_DLCACHE/wamr-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wamr-$ver.tar.gz" | awk '{print $1}')" != "1ab09d51099f276ca4a1d6629f6b589aab2bd0caa01445e05031a4bed22c199b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wamr-$ver.tar.gz" "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/wamr-$ver.tar.gz"
mv "$_TMP"/wasm-micro-runtime-WAMR-* "$_SRCDIR"
