#!/bin/sh
rm -rf pkg src
ver='6.2.0'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/ctags-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ctags-$ver.tar.gz" | awk '{print $1}')" != "ae550fb8c5fdb5dfca2b1fc51a5de69300eddca9eb04bda9cc47b9703041763e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ctags-$ver.tar.gz" "https://github.com/universal-ctags/ctags/releases/download/v$ver/universal-ctags-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/ctags-$ver.tar.gz"
mv universal-ctags-* src
