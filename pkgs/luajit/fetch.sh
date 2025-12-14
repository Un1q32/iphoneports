#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7152e15489d2077cd299ee23e3d51a4c599ab14f'
if [ ! -f "$_DLCACHE/luajit-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luajit-$ver.tar.gz" | awk '{print $1}')" != "2103f2c9526d158259a627d51799de8016e2a2c6d89f6ef25f9d89b92c597511" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luajit-$ver.tar.gz" "https://github.com/LuaJIT/LuaJIT/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/luajit-$ver.tar.gz"
mv "$_TMP"/LuaJIT-* "$_SRCDIR"
