#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.70.0'
if [ ! -f "$_DLCACHE/nghttp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp2-$ver.tar.xz" | awk '{print $1}')" != "e05cb1388eaca3830aded4ccf20044b6e1ac1a61411dcca11b0437c4285c8bc2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp2-$ver.tar.xz" "https://github.com/nghttp2/nghttp2/releases/download/v$ver/nghttp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nghttp2-$ver.tar.xz"
mv "$_TMP"/nghttp2-* "$_SRCDIR"
