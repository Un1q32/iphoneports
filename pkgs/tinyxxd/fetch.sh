#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.3.8'
if [ ! -f "$_DLCACHE/tinyxxd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/tinyxxd-$ver.tar.gz" | awk '{print $1}')" != "c1a355fd50079a594546f5265e7c66ff3a5742767c9935e1e577825099629534" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/tinyxxd-$ver.tar.gz" "https://github.com/xyproto/tinyxxd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/tinyxxd-$ver.tar.gz"
mv "$_TMP"/tinyxxd-* "$_SRCDIR"
