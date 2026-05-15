#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.3.16'
if [ ! -f "$_DLCACHE/tinyxxd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/tinyxxd-$ver.tar.gz" | awk '{print $1}')" != "f74a3cbcdd3166f0f966f97ad483a60a34b53a09abd9ba63783c0958640ca9d9" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/tinyxxd-$ver.tar.gz" "https://github.com/xyproto/tinyxxd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/tinyxxd-$ver.tar.gz"
mv "$_TMP"/tinyxxd-* "$_SRCDIR"
