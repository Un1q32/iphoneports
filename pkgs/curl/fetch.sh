#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.20.0'
if [ ! -f "$_DLCACHE/curl-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/curl-$ver.tar.xz" | awk '{print $1}')" != "63fe2dc148ba0ceae89922ef838f7e5c946272c2e78b7c59fab4b79d3ce2b896" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/curl-$ver.tar.xz" "https://curl.se/download/curl-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/curl-$ver.tar.xz"
mv "$_TMP"/curl-* "$_SRCDIR"
