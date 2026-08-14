#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='a4a838dea856217560d39c0cc898c12a204e3cf3'
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "dc77aa31d961736fa6ab6a65644245de3a0938cfa350560f83ea53f953427db2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv "$_TMP"/cctools-port-* "$_SRCDIR"
