#!/bin/sh
rm -rf pkg src
ver='7e0df5eee9eab872261fd5eb0068cec967a2ba77'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/vim-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/vim-$ver.tar.gz" | awk '{print $1}')" != "68b6d788260e2fd557f56c90867b8e21a7d5acd6e5ed9172ceefa7b8ce80bddd" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/vim-$ver.tar.gz" "https://github.com/vim/vim/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/vim-$ver.tar.gz"
mv vim-* src
