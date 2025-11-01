#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.12.1'
if [ ! -f "$_DLCACHE/ccache-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ccache-$ver.tar.gz" | awk '{print $1}')" != "7250b1d6b9f598049d0a3802b3195c580d7c0b1e9a708d8a9bfbfaf12cbc5fcd" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ccache-$ver.tar.gz" "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/ccache-$ver.tar.gz"
mv ccache-* "$_SRCDIR"
