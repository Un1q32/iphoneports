#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.2-23'
if [ ! -f "$_DLCACHE/imagemagick-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/imagemagick-$ver.tar.xz" | awk '{print $1}')" != "e8f59f0ef722e7abe7a39c16fba8be75a32b3055f9f3319dd8219d1f57af8c05" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/imagemagick-$ver.tar.xz" "https://imagemagick.org/archive/releases/ImageMagick-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/imagemagick-$ver.tar.xz"
mv "$_TMP"/ImageMagick-* "$_SRCDIR"
