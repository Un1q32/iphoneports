#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.14.4'
if [ ! -f "$_DLCACHE/python-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/python-$ver.tar.xz" | awk '{print $1}')" != "d923c51303e38e249136fc1bdf3568d56ecb03214efdef48516176d3d7faaef8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/python-$ver.tar.xz" "https://www.python.org/ftp/python/$ver/Python-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/python-$ver.tar.xz"
mv "$_TMP"/Python-* "$_SRCDIR"
