#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.18.0'
if [ ! -f "$_DLCACHE/ngtcp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ngtcp2-$ver.tar.xz" | awk '{print $1}')" != "aac91fbcb8af77216862cc1bf6e9ddcabfe42b4c373a438b7b1d36b763a4ac5f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ngtcp2-$ver.tar.xz" "https://github.com/ngtcp2/ngtcp2/releases/download/v$ver/ngtcp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ngtcp2-$ver.tar.xz"
mv "$_TMP"/ngtcp2-* "$_SRCDIR"
