#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.20.0'
if [ ! -f "$_DLCACHE/hyperfine-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/hyperfine-$ver.tar.gz" | awk '{print $1}')" != "f90c3b096af568438be7da52336784635a962c9822f10f98e5ad11ae8c7f5c64" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/hyperfine-$ver.tar.gz" "https://github.com/sharkdp/hyperfine/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/hyperfine-$ver.tar.gz"
mv "$_TMP"/hyperfine-* "$_SRCDIR"
