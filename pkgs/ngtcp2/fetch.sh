#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.20.0'
if [ ! -f "$_DLCACHE/ngtcp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ngtcp2-$ver.tar.xz" | awk '{print $1}')" != "7fb5b46bbf73dd43efbad55c707d067fdbafdca3609fc71d96e8f3068c5a6667" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ngtcp2-$ver.tar.xz" "https://github.com/ngtcp2/ngtcp2/releases/download/v$ver/ngtcp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ngtcp2-$ver.tar.xz"
mv "$_TMP"/ngtcp2-* "$_SRCDIR"
