#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.3'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/bash-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/bash-$ver.tar.gz" | awk '{print $1}')" != "0d5cd86965f869a26cf64f4b71be7b96f90a3ba8b3d74e27e8e9d9d5550f31ba" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/bash-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/bash/bash-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/bash-$ver.tar.gz"
mv bash-* "$_SRCDIR"
