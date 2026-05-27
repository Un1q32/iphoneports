#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.2-24'
if [ ! -f "$_DLCACHE/imagemagick-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/imagemagick-$ver.tar.xz" | awk '{print $1}')" != "e44e70aa49e97ceb8b4f68e97829d0bde69b79387d69660b8886b1f6e06ddb19" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/imagemagick-$ver.tar.xz" "https://imagemagick.org/archive/releases/ImageMagick-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/imagemagick-$ver.tar.xz"
mv "$_TMP"/ImageMagick-* "$_SRCDIR"
