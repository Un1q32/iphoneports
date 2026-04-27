#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.10'
if [ ! -f "$_DLCACHE/sed-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/sed-$ver.tar.gz" | awk '{print $1}')" != "4d179ffaf92ec4dcec541f7c032be1c3b9a1856f4970adb95a505221702f5277" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/sed-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/sed/sed-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/sed-$ver.tar.gz"
mv "$_TMP"/sed-* "$_SRCDIR"
