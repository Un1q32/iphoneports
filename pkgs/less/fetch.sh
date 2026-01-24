#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='691'
if [ ! -f "$_DLCACHE/less-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/less-$ver.tar.gz" | awk '{print $1}')" != "88b480eda1bb4f92009f7968b23189eaf1329211f5a3515869e133d286154d25" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/less-$ver.tar.gz" "https://www.greenwoodsoftware.com/less/less-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/less-$ver.tar.gz"
mv "$_TMP"/less-* "$_SRCDIR"
