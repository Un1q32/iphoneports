#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.14.6'
if [ ! -f "$_DLCACHE/python-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/python-$ver.tar.xz" | awk '{print $1}')" != "143b1dddefaec3bd2e21e3b839b34a2b7fb9842272883c576420d605e9f30c63" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/python-$ver.tar.xz" "https://www.python.org/ftp/python/$ver/Python-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/python-$ver.tar.xz"
mv "$_TMP"/Python-* "$_SRCDIR"
