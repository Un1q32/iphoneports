#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='080a4b1b41d8d03ea56654d50d4cc9c344e46eb7'
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "3a283f652138ee6182ac0e895b8979c0c9e99d66f236d46d9d651d70c1470cd5" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv "$_TMP"/cctools-port-* "$_SRCDIR"
