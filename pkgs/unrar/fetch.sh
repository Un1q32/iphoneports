#!/bin/sh
rm -rf pkg src
ver='7.1.10'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/unrar-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/unrar-$ver.tar.gz" | awk '{print $1}')" != "72a9ccca146174f41876e8b21ab27e973f039c6d10b13aabcb320e7055b9bb98" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/unrar-$ver.tar.gz" "https://www.rarlab.com/rar/unrarsrc-$ver.tar.gz"
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/unrar-$ver.tar.gz"
mv unrar src
