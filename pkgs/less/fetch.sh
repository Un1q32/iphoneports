#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='685'
if [ ! -f "$_DLCACHE/less-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/less-$ver.tar.gz" | awk '{print $1}')" != "2701041e767e697ee420ce0825641cedc8f20b51576abe99d92c1666d332e9dc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/less-$ver.tar.gz" "https://www.greenwoodsoftware.com/less/less-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/less-$ver.tar.gz"
mv less-* "$_SRCDIR"
