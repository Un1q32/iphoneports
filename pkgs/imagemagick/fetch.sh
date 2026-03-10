#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.2-16'
if [ ! -f "$_DLCACHE/imagemagick-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/imagemagick-$ver.tar.xz" | awk '{print $1}')" != "bb463666e99145b143de5f4168dc0a8a2d3033ce49ce6aba7915f75076376eaf" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/imagemagick-$ver.tar.xz" "https://imagemagick.org/archive/releases/ImageMagick-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/imagemagick-$ver.tar.xz"
mv "$_TMP"/ImageMagick-* "$_SRCDIR"
