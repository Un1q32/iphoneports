#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.2-30'
if [ ! -f "$_DLCACHE/imagemagick-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/imagemagick-$ver.tar.gz" | awk '{print $1}')" != "3034a64f22398e15ee3dd1e6b1aa83d838cfc47df1bb246ae0eca9590e6ace72" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/imagemagick-$ver.tar.gz" "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/imagemagick-$ver.tar.gz"
mv "$_TMP"/ImageMagick-* "$_SRCDIR"
