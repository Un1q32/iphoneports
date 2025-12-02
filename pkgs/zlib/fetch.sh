#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.3.2'
if [ ! -f "$_DLCACHE/zlib-ng-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/zlib-ng-$ver.tar.gz" | awk '{print $1}')" != "6a0561b50b8f5f6434a6a9e667a67026f2b2064a1ffa959c6b2dae320161c2a8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/zlib-ng-$ver.tar.gz" "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/zlib-ng-$ver.tar.gz"
mv "$_TMP"/zlib-ng-* "$_SRCDIR"
