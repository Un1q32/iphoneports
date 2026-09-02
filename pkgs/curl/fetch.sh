#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.22.0'
if [ ! -f "$_DLCACHE/curl-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/curl-$ver.tar.xz" | awk '{print $1}')" != "f7ef3ae8a22e521f289803fe93543eb64c329b58aa73a9e224dfd915a2a5f4f7" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/curl-$ver.tar.xz" "https://curl.se/download/curl-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/curl-$ver.tar.xz"
mv "$_TMP"/curl-* "$_SRCDIR"
