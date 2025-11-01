#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.13.1'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/ninja-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ninja-$ver.tar.gz" | awk '{print $1}')" != "f0055ad0369bf2e372955ba55128d000cfcc21777057806015b45e4accbebf23" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ninja-$ver.tar.gz" "https://github.com/ninja-build/ninja/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/ninja-$ver.tar.gz"
mv ninja-* "$_SRCDIR"
