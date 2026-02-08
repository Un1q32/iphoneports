#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.12.3'
if [ ! -f "$_DLCACHE/ccache-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ccache-$ver.tar.gz" | awk '{print $1}')" != "681c79e361a26a0bc449507100fa44d9c6831d4c91041634e9310f5538df2a35" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ccache-$ver.tar.gz" "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ccache-$ver.tar.gz"
mv "$_TMP"/ccache-* "$_SRCDIR"
