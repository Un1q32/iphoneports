#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.1'
if [ ! -f "$_DLCACHE/ffmpeg-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ffmpeg-$ver.tar.xz" | awk '{print $1}')" != "b072aed6871998cce9b36e7774033105ca29e33632be5b6347f3206898e0756a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ffmpeg-$ver.tar.xz" "https://ffmpeg.org/releases/ffmpeg-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ffmpeg-$ver.tar.xz"
mv "$_TMP"/ffmpeg-* "$_SRCDIR"
