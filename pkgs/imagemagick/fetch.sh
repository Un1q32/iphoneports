#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.2-18'
if [ ! -f "$_DLCACHE/imagemagick-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/imagemagick-$ver.tar.xz" | awk '{print $1}')" != "abb85df40f06fddf17d031629c7ad2778a55d478a8bff80d55ffee75c90a3982" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/imagemagick-$ver.tar.xz" "https://imagemagick.org/archive/releases/ImageMagick-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/imagemagick-$ver.tar.xz"
mv "$_TMP"/ImageMagick-* "$_SRCDIR"
