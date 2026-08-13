#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.8'
if [ ! -f "$_DLCACHE/pigz-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/pigz-$ver.tar.gz" | awk '{print $1}')" != "" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pigz-$ver.tar.gz" "https://github.com/madler/pigz/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/pigz-$ver.tar.gz"
mv "$_TMP"/pigz-* "$_SRCDIR"
