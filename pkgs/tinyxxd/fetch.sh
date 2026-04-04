#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.3.15'
if [ ! -f "$_DLCACHE/tinyxxd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/tinyxxd-$ver.tar.gz" | awk '{print $1}')" != "4a0103c8a386443e9c6c893d7f01c0c8b3f5f92c3dc4bcbb0ae6570ac6289c1d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/tinyxxd-$ver.tar.gz" "https://github.com/xyproto/tinyxxd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/tinyxxd-$ver.tar.gz"
mv "$_TMP"/tinyxxd-* "$_SRCDIR"
