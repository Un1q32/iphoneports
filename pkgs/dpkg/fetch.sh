#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.23.5'
if [ ! -f "$_DLCACHE/dpkg-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/dpkg-$ver.tar.bz2" | awk '{print $1}')" != "9c5797e0c76381d13896b2d3b3f95d9ac41a6fdee7d3eef923afc479dc3cebfc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dpkg-$ver.tar.bz2" "https://salsa.debian.org/dpkg-team/dpkg/-/archive/$ver/dpkg-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dpkg-$ver.tar.bz2"
mv "$_TMP"/dpkg-* "$_SRCDIR"
printf '%s\n' "$ver" > "$_SRCDIR/.dist-version"
