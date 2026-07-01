#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.15.1'
if [ ! -f "$_DLCACHE/jansson-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/jansson-$ver.tar.bz2" | awk '{print $1}')" != "f9aa4b3ec8496fee69db94f06f3d76fd4a26b012ee9bf1e917078c2cd2841881" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/jansson-$ver.tar.bz2" "https://github.com/akheron/jansson/releases/download/v$ver/jansson-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/jansson-$ver.tar.bz2"
mv "$_TMP"/jansson-* "$_SRCDIR"
