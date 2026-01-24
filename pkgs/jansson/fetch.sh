#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.15.0'
if [ ! -f "$_DLCACHE/jansson-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/jansson-$ver.tar.bz2" | awk '{print $1}')" != "a7eac7765000373165f9373eb748be039c10b2efc00be9af3467ec92357d8954" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/jansson-$ver.tar.bz2" "https://github.com/akheron/jansson/releases/download/v$ver/jansson-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/jansson-$ver.tar.bz2"
mv "$_TMP"/jansson-* "$_SRCDIR"
