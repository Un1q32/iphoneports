#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1c3b5a4d722598ecbb9219480142eda682e87bb1'
if [ ! -f "$_DLCACHE/luajit-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luajit-$ver.tar.gz" | awk '{print $1}')" != "3e2b93dbb545df2eaa5107c348d6f700404eb5d4e1c04e010abd794b963362d8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luajit-$ver.tar.gz" "https://github.com/LuaJIT/LuaJIT/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/luajit-$ver.tar.gz"
mv "$_TMP"/LuaJIT-* "$_SRCDIR"
