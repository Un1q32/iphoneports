#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.14.0'
if [ ! -f "$_DLCACHE/nghttp3-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/nghttp3-$ver.tar.xz" | awk '{print $1}')" != "b3083dae2ff30cf00d24d5fedd432479532c7b17d993d384103527b36c1ec82d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nghttp3-$ver.tar.xz" "https://github.com/ngtcp2/nghttp3/releases/download/v$ver/nghttp3-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nghttp3-$ver.tar.xz"
mv "$_TMP"/nghttp3-* "$_SRCDIR"
