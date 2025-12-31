#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.2.1'
if [ ! -f "$_DLCACHE/wget2-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wget2-$ver.tar.gz" | awk '{print $1}')" != "d7544b13e37f18e601244fce5f5f40688ac1d6ab9541e0fbb01a32ee1fb447b4" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wget2-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/wget/wget2-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/wget2-$ver.tar.gz"
mv "$_TMP"/wget2-* "$_SRCDIR"
