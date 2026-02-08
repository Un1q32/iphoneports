#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.12.3'
if [ ! -f "$_DLCACHE/ccache-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ccache-$ver.tar.gz" | awk '{print $1}')" != "89a9df3b291c4df9f8b9e1696c4f811e548568171954cb14c00f621c0db66127" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ccache-$ver.tar.gz" "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ccache-$ver.tar.gz"
mv "$_TMP"/ccache-* "$_SRCDIR"
