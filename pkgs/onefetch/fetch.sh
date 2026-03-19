#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.27.1'
if [ ! -f "$_DLCACHE/onefetch-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/onefetch-$ver.tar.gz" | awk '{print $1}')" != "3a6f82d3da4da62b2e5406bbe307b0afc73cd8fcc4855534886d80ea0121cc03" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/onefetch-$ver.tar.gz" "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/onefetch-$ver.tar.gz"
mv "$_TMP"/onefetch-* "$_SRCDIR"
