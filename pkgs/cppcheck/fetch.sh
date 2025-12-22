#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.19.0'
if [ ! -f "$_DLCACHE/cppcheck-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cppcheck-$ver.tar.gz" | awk '{print $1}')" != "c6cff9d3bbcb3da941bf7f525ae974b6c7af3d610c4c5519fcd1be3f21f5ae09" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cppcheck-$ver.tar.gz" "https://github.com/danmar/cppcheck/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cppcheck-$ver.tar.gz"
mv "$_TMP"/cppcheck-* "$_SRCDIR"
