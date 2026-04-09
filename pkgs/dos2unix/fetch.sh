#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.5.5'
if [ ! -f "$_DLCACHE/dos2unix-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/dos2unix-$ver.tar.gz" | awk '{print $1}')" != "75f692b8484c8c24579a2ffd87df16b9c9428ed95497e3393a21d1ba0697ac33" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dos2unix-$ver.tar.gz" "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dos2unix-$ver.tar.gz"
mv "$_TMP"/dos2unix-* "$_SRCDIR"
