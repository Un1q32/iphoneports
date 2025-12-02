#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.3.2'
if [ ! -f "$_DLCACHE/zlib-ng-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/zlib-ng-$ver.tar.gz" | awk '{print $1}')" != "94cfa0a53a8265c813c8369d3963bf09ac6a357824ad1f93aee13486176e152e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/zlib-ng-$ver.tar.gz" "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/zlib-ng-$ver.tar.gz"
mv "$_TMP"/zlib-ng-* "$_SRCDIR"
