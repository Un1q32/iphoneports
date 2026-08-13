#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.61'
if [ ! -f "$_DLCACHE/libgpg-error-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/libgpg-error-$ver.tar.bz2" | awk '{print $1}')" != "d856f3582d31fd754afe876abf6f269e4f2f4e75c7ca2047971fb6e9b1d6e552" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgpg-error-$ver.tar.bz2" "https://github.com/gpg/libgpg-error/archive/refs/tags/libgpg-error-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libgpg-error-$ver.tar.bz2"
mv "$_TMP"/libgpg-error-* "$_SRCDIR"
