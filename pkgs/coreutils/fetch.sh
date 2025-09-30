#!/bin/sh
rm -rf pkg src
ver='9.8'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/coreutils-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/coreutils-$ver.tar.xz" | awk '{print $1}')" != "e6d4fd2d852c9141a1c2a18a13d146a0cd7e45195f72293a4e4c044ec6ccca15" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/coreutils-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-$ver.tar.xz"
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/coreutils-$ver.tar.xz"
mv coreutils-* src
