#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='c2734dc03cd9ee437d25a6940e8c37ac7873b01d'
if [ ! -f "$_DLCACHE/vim-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/vim-$ver.tar.gz" | awk '{print $1}')" != "ac992c44ecd00ea4d62b56ef41efafc9bcd5f83dfb6925b7a6d92bc943d855a9" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/vim-$ver.tar.gz" "https://github.com/vim/vim/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/vim-$ver.tar.gz"
mv "$_TMP"/vim-* "$_SRCDIR"
