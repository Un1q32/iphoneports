#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='162231ead6217ef5ee231293004c8aa68681a7bc'
if [ ! -f "$_DLCACHE/nextvi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nextvi-$ver.tar.gz" | awk '{print $1}')" != "2f87ec6e957eafe0157b664261f9511e12d8528113bb2d64b0fac88e99e8154b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nextvi-$ver.tar.gz" "https://github.com/Un1q32/nextvi/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nextvi-$ver.tar.gz"
mv "$_TMP"/nextvi-* "$_SRCDIR"
