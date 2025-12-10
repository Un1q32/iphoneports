#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.34.6'
if [ ! -f "$_DLCACHE/c-ares-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/c-ares-$ver.tar.gz" | awk '{print $1}')" != "4358939ff800b13b92f37d5fdda003718101faedfbdee792d6b79ddc1a53d890" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/c-ares-$ver.tar.gz" "https://github.com/c-ares/c-ares/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/c-ares-$ver.tar.gz"
mv "$_TMP"/c-ares-* "$_SRCDIR"
