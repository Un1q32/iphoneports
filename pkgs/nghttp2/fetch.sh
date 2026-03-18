#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.68.1'
if [ ! -f "$_DLCACHE/nghttp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp2-$ver.tar.xz" | awk '{print $1}')" != "6abd7ab0a7f1580d5914457cb3c85eb80455657ee5119206edbd7f848c14f0b2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp2-$ver.tar.xz" "https://github.com/nghttp2/nghttp2/releases/download/v$ver/nghttp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nghttp2-$ver.tar.xz"
mv "$_TMP"/nghttp2-* "$_SRCDIR"
