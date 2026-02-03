#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.3.10'
if [ ! -f "$_DLCACHE/tinyxxd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/tinyxxd-$ver.tar.gz" | awk '{print $1}')" != "85c8c8abf8d05cb1584af4dabd27a04397db417a7b92f890888153c52411b64a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/tinyxxd-$ver.tar.gz" "https://github.com/xyproto/tinyxxd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/tinyxxd-$ver.tar.gz"
mv "$_TMP"/tinyxxd-* "$_SRCDIR"
