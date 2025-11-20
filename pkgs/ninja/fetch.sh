#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.13.2'
if [ ! -f "$_DLCACHE/ninja-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ninja-$ver.tar.gz" | awk '{print $1}')" != "974d6b2f4eeefa25625d34da3cb36bdcebe7fbce40f4c16ac0835fd1c0cbae17" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ninja-$ver.tar.gz" "https://github.com/ninja-build/ninja/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ninja-$ver.tar.gz"
mv "$_TMP"/ninja-* "$_SRCDIR"
