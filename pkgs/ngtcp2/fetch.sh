#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.19.0'
if [ ! -f "$_DLCACHE/ngtcp2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ngtcp2-$ver.tar.xz" | awk '{print $1}')" != "f11f7da5065f2298f8b5f079a11f1a6f72389271b8dedd893c8eb26aba94bce9" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ngtcp2-$ver.tar.xz" "https://github.com/ngtcp2/ngtcp2/releases/download/v$ver/ngtcp2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ngtcp2-$ver.tar.xz"
mv "$_TMP"/ngtcp2-* "$_SRCDIR"
