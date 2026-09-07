#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.737'
if [ ! -f "$_DLCACHE/luau-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luau-$ver.tar.gz" | awk '{print $1}')" != "767b872f084518ca9a79b021f83b40e6a051be4c1f91dd712a949417a4e979c6" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luau-$ver.tar.gz" "https://github.com/luau-lang/luau/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/luau-$ver.tar.gz"
mv "$_TMP"/luau-* "$_SRCDIR"
