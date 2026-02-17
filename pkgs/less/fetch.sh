#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='692'
if [ ! -f "$_DLCACHE/less-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/less-$ver.tar.gz" | awk '{print $1}')" != "61300f603798ecf1d7786570789f0ff3f5a1acf075a6fb9f756837d166e37d14" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/less-$ver.tar.gz" "https://www.greenwoodsoftware.com/less/less-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/less-$ver.tar.gz"
mv "$_TMP"/less-* "$_SRCDIR"
