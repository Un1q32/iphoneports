#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.17.0'
if [ ! -f "$_DLCACHE/nghttp3-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp3-$ver.tar.xz" | awk '{print $1}')" != "e8b798272b9282045cb83577dcf7bd7fcd22bb3a43aec0eb1a24f675b4cef0b8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp3-$ver.tar.xz" "https://github.com/ngtcp2/nghttp3/releases/download/v$ver/nghttp3-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nghttp3-$ver.tar.xz"
mv "$_TMP"/nghttp3-* "$_SRCDIR"
