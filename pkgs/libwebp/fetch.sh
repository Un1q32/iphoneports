#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.6.0'
if [ ! -f "$_DLCACHE/libwebp-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libwebp-$ver.tar.gz" | awk '{print $1}')" != "e4ab7009bf0629fd11982d4c2aa83964cf244cffba7347ecd39019a9e38c4564" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libwebp-$ver.tar.gz" "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libwebp-$ver.tar.gz"
mv "$_TMP"/libwebp-* "$_SRCDIR"
