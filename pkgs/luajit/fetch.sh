#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='c6ffc141a8762b41703f9287d63d93622a13dd8f'
if [ ! -f "$_DLCACHE/luajit-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luajit-$ver.tar.gz" | awk '{print $1}')" != "6e5fec07750add912e7c3eae0c194d24cd6d023714e1f04a0298a5b4819e4457" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luajit-$ver.tar.gz" "https://github.com/LuaJIT/LuaJIT/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/luajit-$ver.tar.gz"
mv "$_TMP"/LuaJIT-* "$_SRCDIR"
