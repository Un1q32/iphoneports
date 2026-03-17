#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.3.2'
if [ ! -f "$_DLCACHE/tree-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/tree-$ver.tar.gz" | awk '{print $1}')" != "6b941dd6cbecfb4d3250700e4d08d8e0c251488981dd4868b90d744234300e21" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/tree-$ver.tar.gz" "https://oldmanprogrammer.net/tar/tree/tree-$ver.tgz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/tree-$ver.tar.gz"
mv "$_TMP"/tree-* "$_SRCDIR"
