#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.0.7'
if [ ! -f "$_DLCACHE/pkgconf-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/pkgconf-$ver.tar.gz" | awk '{print $1}')" != "a9ae678879771fcf15247ac2435e7ad8308be8a5921898e6720b3b8949410f73" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pkgconf-$ver.tar.gz" "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/pkgconf-$ver.tar.gz"
mv "$_TMP"/pkgconf-* "$_SRCDIR"
