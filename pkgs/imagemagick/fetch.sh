#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.2-19'
if [ ! -f "$_DLCACHE/imagemagick-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/imagemagick-$ver.tar.xz" | awk '{print $1}')" != "4ffd17387d0b55c1f7465ea2baf39e1404afcfe7321ee66430741045d282fc6a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/imagemagick-$ver.tar.xz" "https://imagemagick.org/archive/releases/ImageMagick-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/imagemagick-$ver.tar.xz"
mv "$_TMP"/ImageMagick-* "$_SRCDIR"
