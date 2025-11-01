#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.0'
if [ ! -f "$_DLCACHE/ffmpeg-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ffmpeg-$ver.tar.xz" | awk '{print $1}')" != "b2751fccb6cc4c77708113cd78b561059b6fa904b24162fa0be2d60273d27b8e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ffmpeg-$ver.tar.xz" "https://ffmpeg.org/releases/ffmpeg-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ffmpeg-$ver.tar.xz"
mv "$_TMP"/ffmpeg-* "$_SRCDIR"
