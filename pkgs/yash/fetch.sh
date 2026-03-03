#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.61'
if [ ! -f "$_DLCACHE/yash-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/yash-$ver.tar.xz" | awk '{print $1}')" != "06401f8abfad7ac3bdbce66ccda2c37878fa103a53a3c3ed35e386f2514dd9bd" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/yash-$ver.tar.xz" "https://github.com/magicant/yash/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/yash-$ver.tar.xz"
mv "$_TMP"/yash-* "$_SRCDIR"
