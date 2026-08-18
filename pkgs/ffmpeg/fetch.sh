#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='9.0'
if [ ! -f "$_DLCACHE/ffmpeg-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/ffmpeg-$ver.tar.xz" | awk '{print $1}')" != "7f607a00dd0d28a729d5a4811205812eef01cf6ef6155025febb6f36a9062d52" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ffmpeg-$ver.tar.xz" "https://ffmpeg.org/releases/ffmpeg-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ffmpeg-$ver.tar.xz"
mv "$_TMP"/ffmpeg-* "$_SRCDIR"
