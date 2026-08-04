#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.5.1'
if [ ! -f "$_DLCACHE/lua-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/lua-$ver.tar.gz" | awk '{print $1}')" != "1c4b4068d67061f2a2231ad2b5422e77acea1487ea9890f6320af614f4373dce" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/lua-$ver.tar.gz" "https://www.lua.org/ftp/lua-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/lua-$ver.tar.gz"
mv "$_TMP"/lua-* "$_SRCDIR"
