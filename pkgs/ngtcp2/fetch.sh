#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.21.0'
if [ ! -f "$_DLCACHE/ngtcp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ngtcp2-$ver.tar.xz" | awk '{print $1}')" != "2d1c07e6aa509c017516c08307b0b707cd165a17275ab5f1caff9aaa0e3b6c7d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ngtcp2-$ver.tar.xz" "https://github.com/ngtcp2/ngtcp2/releases/download/v$ver/ngtcp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ngtcp2-$ver.tar.xz"
mv "$_TMP"/ngtcp2-* "$_SRCDIR"
