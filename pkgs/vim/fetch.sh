#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5d934b1bdb803c652a521f04481f92b2c2fa029e'
if [ ! -f "$_DLCACHE/vim-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/vim-$ver.tar.gz" | awk '{print $1}')" != "80998c84f92ae8860fc3bdd625ff74a58c6cf63461973aae69a53dcd24400067" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/vim-$ver.tar.gz" "https://github.com/vim/vim/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/vim-$ver.tar.gz"
mv "$_TMP"/vim-* "$_SRCDIR"
