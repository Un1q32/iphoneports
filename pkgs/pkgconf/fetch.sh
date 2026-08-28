#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.0.6'
if [ ! -f "$_DLCACHE/pkgconf-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/pkgconf-$ver.tar.gz" | awk '{print $1}')" != "a32d9dd8fc3d1179d0755df471a561842a0f2475013da9c5cf86e38215a61380" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pkgconf-$ver.tar.gz" "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/pkgconf-$ver.tar.gz"
mv "$_TMP"/pkgconf-* "$_SRCDIR"
