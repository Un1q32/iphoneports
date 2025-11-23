#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.0.1'
if [ ! -f "$_DLCACHE/ffmpeg-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ffmpeg-$ver.tar.xz" | awk '{print $1}')" != "05ee0b03119b45c0bdb4df654b96802e909e0a752f72e4fe3794f487229e5a41" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ffmpeg-$ver.tar.xz" "https://ffmpeg.org/releases/ffmpeg-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ffmpeg-$ver.tar.xz"
mv "$_TMP"/ffmpeg-* "$_SRCDIR"
