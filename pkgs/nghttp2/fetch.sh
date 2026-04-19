#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.69.0'
if [ ! -f "$_DLCACHE/nghttp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp2-$ver.tar.xz" | awk '{print $1}')" != "1fb324b6ec2c56f6bde0658f4139ffd8209fa9e77ce98fd7a5f63af8d0e508ad" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp2-$ver.tar.xz" "https://github.com/nghttp2/nghttp2/releases/download/v$ver/nghttp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nghttp2-$ver.tar.xz"
mv "$_TMP"/nghttp2-* "$_SRCDIR"
