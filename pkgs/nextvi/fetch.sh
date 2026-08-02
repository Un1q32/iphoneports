#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8ff1d7d849afbedb6988182779b082717cdfb77d'
if [ ! -f "$_DLCACHE/nextvi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nextvi-$ver.tar.gz" | awk '{print $1}')" != "f176fe107690d83175790f15140ca9682519aa8a8cc2386f6de144f3ff9f8b2c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nextvi-$ver.tar.gz" "https://github.com/Un1q32/nextvi/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nextvi-$ver.tar.gz"
mv "$_TMP"/nextvi-* "$_SRCDIR"
