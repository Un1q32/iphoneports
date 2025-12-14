#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.703'
if [ ! -f "$_DLCACHE/luau-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luau-$ver.tar.gz" | awk '{print $1}')" != "e661d85d03244cf6c00e5a17b493e19714b7b414b3bf8b9d1ae20b508ba2980f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luau-$ver.tar.gz" "https://github.com/luau-lang/luau/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/luau-$ver.tar.gz"
mv "$_TMP"/luau-* "$_SRCDIR"
