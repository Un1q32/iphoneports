#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.14.1'
if [ ! -f "$_DLCACHE/python-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/python-$ver.tar.xz" | awk '{print $1}')" != "8dfa08b1959d9d15838a1c2dab77dc8d8ff4a553a1ed046dfacbc8095c6d42fc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/python-$ver.tar.xz" "https://www.python.org/ftp/python/$ver/Python-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/python-$ver.tar.xz"
mv "$_TMP"/Python-* "$_SRCDIR"
