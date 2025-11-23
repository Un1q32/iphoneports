#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.13.0'
if [ ! -f "$_DLCACHE/nghttp3-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp3-$ver.tar.xz" | awk '{print $1}')" != "926d358a74d6f15e5a11239e3e980dd4c66332e52e4d1b38c2cf8820458ad4d8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp3-$ver.tar.xz" "https://github.com/ngtcp2/nghttp3/releases/download/v$ver/nghttp3-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nghttp3-$ver.tar.xz"
mv "$_TMP"/nghttp3-* "$_SRCDIR"
