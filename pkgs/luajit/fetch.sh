#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='194d7f2d635a11193177f0ed820ae419148f0b70'
if [ ! -f "$_DLCACHE/luajit-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luajit-$ver.tar.gz" | awk '{print $1}')" != "6a9c168d002f698bd8c76d5bb2e3ee3615297c9c8e4cf00992a04a4e5baaac56" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luajit-$ver.tar.gz" "https://github.com/LuaJIT/LuaJIT/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/luajit-$ver.tar.gz"
mv "$_TMP"/LuaJIT-* "$_SRCDIR"
