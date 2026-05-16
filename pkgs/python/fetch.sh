#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.14.5'
if [ ! -f "$_DLCACHE/python-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/python-$ver.tar.xz" | awk '{print $1}')" != "7e32597b99e5d9a39abed35de4693fa169df3e5850d4c334337ffd6a19a36db6" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/python-$ver.tar.xz" "https://www.python.org/ftp/python/$ver/Python-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/python-$ver.tar.xz"
mv "$_TMP"/Python-* "$_SRCDIR"
