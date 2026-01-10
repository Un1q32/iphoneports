#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='707c12bf00dafdfd3899b1a6c36435dbbf6c7022'
if [ ! -f "$_DLCACHE/luajit-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luajit-$ver.tar.gz" | awk '{print $1}')" != "ac2defd1e9b4ab07ac0a52f2403318ffb0d54505b975dff0cfc49a927ab84d90" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luajit-$ver.tar.gz" "https://github.com/LuaJIT/LuaJIT/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/luajit-$ver.tar.gz"
mv "$_TMP"/LuaJIT-* "$_SRCDIR"
