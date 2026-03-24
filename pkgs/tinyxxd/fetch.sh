#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.3.14'
if [ ! -f "$_DLCACHE/tinyxxd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/tinyxxd-$ver.tar.gz" | awk '{print $1}')" != "0b45b377d9648a48be3f46286e08016da0cb2017cd39448b0d272f5441bd0baf" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/tinyxxd-$ver.tar.gz" "https://github.com/xyproto/tinyxxd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/tinyxxd-$ver.tar.gz"
mv "$_TMP"/tinyxxd-* "$_SRCDIR"
