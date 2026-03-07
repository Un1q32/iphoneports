#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.4.0'
if [ ! -f "$_DLCACHE/fd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/fd-$ver.tar.gz" | awk '{print $1}')" != "9caf8509134fe304ce5ee4667804216d93fe61df11ff941f48a240d40495db16" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/fd-$ver.tar.gz" "https://github.com/sharkdp/fd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/fd-$ver.tar.gz"
mv "$_TMP"/fd-* "$_SRCDIR"
