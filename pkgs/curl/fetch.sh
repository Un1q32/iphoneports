#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.21.0'
if [ ! -f "$_DLCACHE/curl-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/curl-$ver.tar.xz" | awk '{print $1}')" != "aa1b66a70eace83dc624508745646c08ae561de512ab403adffb93ac87fc72e6" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/curl-$ver.tar.xz" "https://curl.se/download/curl-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/curl-$ver.tar.xz"
mv "$_TMP"/curl-* "$_SRCDIR"
