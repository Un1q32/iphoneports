#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.14.0'
if [ ! -f "$_DLCACHE/python-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/python-$ver.tar.xz" | awk '{print $1}')" != "2299dae542d395ce3883aca00d3c910307cd68e0b2f7336098c8e7b7eee9f3e9" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/python-$ver.tar.xz" "https://www.python.org/ftp/python/$ver/Python-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/python-$ver.tar.xz"
mv Python-* "$_SRCDIR"
