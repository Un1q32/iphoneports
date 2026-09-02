#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.0.0'
if [ ! -f "$_DLCACHE/wasmi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wasmi-$ver.tar.gz" | awk '{print $1}')" != "089ac412a1f8ac701d87c3d93e4b3b793972d13c079d1fa6e67a45f34ded3f50" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wasmi-$ver.tar.gz" "https://github.com/wasmi-labs/wasmi/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/wasmi-$ver.tar.gz"
mv "$_TMP"/wasmi-* "$_SRCDIR"
