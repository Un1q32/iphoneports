#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.3.0'
if [ ! -f "$_DLCACHE/fd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/fd-$ver.tar.gz" | awk '{print $1}')" != "2edbc917a533053855d5b635dff368d65756ce6f82ddefd57b6c202622d791e9" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/fd-$ver.tar.gz" "https://github.com/sharkdp/fd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/fd-$ver.tar.gz"
mv "$_TMP"/fd-* "$_SRCDIR"
