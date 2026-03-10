#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.4.2'
if [ ! -f "$_DLCACHE/fd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/fd-$ver.tar.gz" | awk '{print $1}')" != "3a7e027af8c8e91c196ac259c703d78cd55c364706ddafbc66d02c326e57a456" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/fd-$ver.tar.gz" "https://github.com/sharkdp/fd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/fd-$ver.tar.gz"
mv "$_TMP"/fd-* "$_SRCDIR"
