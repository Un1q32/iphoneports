#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.5.2'
if [ ! -f "$_DLCACHE/dav1d-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/dav1d-$ver.tar.bz2" | awk '{print $1}')" != "c748a3214cf02a6d23bc179a0e8caea9d6ece1e46314ef21f5508ca6b5de6262" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dav1d-$ver.tar.bz2" "https://code.videolan.org/videolan/dav1d/-/archive/$ver/dav1d-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dav1d-$ver.tar.bz2"
mv "$_TMP"/dav1d-* "$_SRCDIR"
