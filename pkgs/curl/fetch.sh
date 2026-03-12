#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.19.0'
if [ ! -f "$_DLCACHE/curl-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/curl-$ver.tar.xz" | awk '{print $1}')" != "4eb41489790d19e190d7ac7e18e82857cdd68af8f4e66b292ced562d333f11df" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/curl-$ver.tar.xz" "https://curl.se/download/curl-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/curl-$ver.tar.xz"
mv "$_TMP"/curl-* "$_SRCDIR"
