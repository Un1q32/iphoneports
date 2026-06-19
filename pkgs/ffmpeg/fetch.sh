#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.1.2'
if [ ! -f "$_DLCACHE/ffmpeg-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ffmpeg-$ver.tar.xz" | awk '{print $1}')" != "464beb5e7bf0c311e68b45ae2f04e9cc2af88851abb4082231742a74d97b524c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ffmpeg-$ver.tar.xz" "https://ffmpeg.org/releases/ffmpeg-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ffmpeg-$ver.tar.xz"
mv "$_TMP"/ffmpeg-* "$_SRCDIR"
