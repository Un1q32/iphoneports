#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.13'
if [ ! -f "$_DLCACHE/ccache-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ccache-$ver.tar.gz" | awk '{print $1}')" != "927267067ae30dbbbdb3ae30e1e5aca7c20571232b9eb4f409033614095f36ea" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ccache-$ver.tar.gz" "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ccache-$ver.tar.gz"
mv "$_TMP"/ccache-* "$_SRCDIR"
