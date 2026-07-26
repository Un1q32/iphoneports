#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.18.0'
if [ ! -f "$_DLCACHE/nghttp3-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp3-$ver.tar.xz" | awk '{print $1}')" != "aad782c23d3f01bd4bb52c8bac7a553b631ef8115fd1612703df6183449fef19" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp3-$ver.tar.xz" "https://github.com/ngtcp2/nghttp3/releases/download/v$ver/nghttp3-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nghttp3-$ver.tar.xz"
mv "$_TMP"/nghttp3-* "$_SRCDIR"
