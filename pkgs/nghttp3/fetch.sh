#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.13.1'
if [ ! -f "$_DLCACHE/nghttp3-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp3-$ver.tar.xz" | awk '{print $1}')" != "020836668c711d5c166969f8b165fbfd989e6967d0601947bf608f29e2158518" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp3-$ver.tar.xz" "https://github.com/ngtcp2/nghttp3/releases/download/v$ver/nghttp3-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nghttp3-$ver.tar.xz"
mv "$_TMP"/nghttp3-* "$_SRCDIR"
