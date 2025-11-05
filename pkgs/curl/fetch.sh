#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.17.0'
if [ ! -f "$_DLCACHE/curl-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/curl-$ver.tar.xz" | awk '{print $1}')" != "955f6e729ad6b3566260e8fef68620e76ba3c31acf0a18524416a185acf77992" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/curl-$ver.tar.xz" "https://curl.se/download/curl-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/curl-$ver.tar.xz"
mv "$_TMP"/curl-* "$_SRCDIR"
