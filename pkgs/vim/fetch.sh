#!/bin/sh
rm -rf pkg src
ver='6800da6ff115014aa71fdd396cd1496ea0da6509'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/vim-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/vim-$ver.tar.gz" | awk '{print $1}')" != "122fee536f1df77a1757526f9c22ab4a5ba8a4dd846cf7f02cc73fc5b60cdb98" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/vim-$ver.tar.gz" "https://github.com/vim/vim/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/vim-$ver.tar.gz"
mv vim-* src
