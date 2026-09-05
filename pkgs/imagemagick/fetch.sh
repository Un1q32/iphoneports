#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.2-31'
if [ ! -f "$_DLCACHE/imagemagick-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/imagemagick-$ver.tar.gz" | awk '{print $1}')" != "34d9cc3acddc3e3c429d23af60eda5ceaac477a8b296ddb9469f773f44a80a5f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/imagemagick-$ver.tar.gz" "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/imagemagick-$ver.tar.gz"
mv "$_TMP"/ImageMagick-* "$_SRCDIR"
