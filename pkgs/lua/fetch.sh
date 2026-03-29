#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.4.8'
if [ ! -f "$_DLCACHE/lua-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/lua-$ver.tar.gz" | awk '{print $1}')" != "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/lua-$ver.tar.gz" "https://www.lua.org/ftp/lua-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/lua-$ver.tar.gz"
mv "$_TMP"/lua-* "$_SRCDIR"
