#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.14.7'
if [ ! -f "$_DLCACHE/python-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/python-$ver.tar.xz" | awk '{print $1}')" != "3b48dac8fb59f62eaa67ac83c1eb12bda1b7a08406dd286e252c11a66be27f81" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/python-$ver.tar.xz" "https://www.python.org/ftp/python/$ver/Python-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/python-$ver.tar.xz"
mv "$_TMP"/Python-* "$_SRCDIR"
