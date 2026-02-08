#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.5.4'
if [ ! -f "$_DLCACHE/dos2unix-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/dos2unix-$ver.tar.gz" | awk '{print $1}')" != "f811a2b9e4a0c936c61ef7c1732993d1820e5cf011f4d93861885ccb8101ca21" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dos2unix-$ver.tar.gz" "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dos2unix-$ver.tar.gz"
mv "$_TMP"/dos2unix-* "$_SRCDIR"
