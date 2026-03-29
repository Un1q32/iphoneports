#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.11.7'
if [ ! -f "$_DLCACHE/neovim-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/neovim-$ver.tar.gz" | awk '{print $1}')" != "b550b0e4cd2a0f9558bc6b278d27e47b528f7684efa2a46def438fcd64ee9822" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/neovim-$ver.tar.gz" "https://github.com/neovim/neovim/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/neovim-$ver.tar.gz"
mv "$_TMP"/neovim-* "$_SRCDIR"
