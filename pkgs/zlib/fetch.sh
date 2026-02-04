#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.3.3'
if [ ! -f "$_DLCACHE/zlib-ng-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/zlib-ng-$ver.tar.gz" | awk '{print $1}')" != "f9c65aa9c852eb8255b636fd9f07ce1c406f061ec19a2e7d508b318ca0c907d1" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/zlib-ng-$ver.tar.gz" "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/zlib-ng-$ver.tar.gz"
mv "$_TMP"/zlib-ng-* "$_SRCDIR"
