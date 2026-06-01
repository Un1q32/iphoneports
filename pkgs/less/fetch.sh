#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='702'
if [ ! -f "$_DLCACHE/less-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/less-$ver.tar.gz" | awk '{print $1}')" != "242a64c00f02d96f8ee208cf638ae1728b727c7f5fdf82a7d4f4cae32fb084e2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/less-$ver.tar.gz" "https://www.greenwoodsoftware.com/less/less-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/less-$ver.tar.gz"
mv "$_TMP"/less-* "$_SRCDIR"
