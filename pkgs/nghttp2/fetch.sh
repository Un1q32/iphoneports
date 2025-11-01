#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.68.0'
if [ ! -f "$_DLCACHE/nghttp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp2-$ver.tar.xz" | awk '{print $1}')" != "5511d3128850e01b5b26ec92bf39df15381c767a63441438b25ad6235def902c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp2-$ver.tar.xz" "https://github.com/nghttp2/nghttp2/releases/download/v$ver/nghttp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/nghttp2-$ver.tar.xz"
mv nghttp2-* "$_SRCDIR"
