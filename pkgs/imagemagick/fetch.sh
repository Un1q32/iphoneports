#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.2-29'
if [ ! -f "$_DLCACHE/imagemagick-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/imagemagick-$ver.tar.gz" | awk '{print $1}')" != "b05924ad73c6932ba62c9b32f338f0619b90b767162c8b767f3566556187a284" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/imagemagick-$ver.tar.gz" "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/imagemagick-$ver.tar.gz"
mv "$_TMP"/ImageMagick-* "$_SRCDIR"
