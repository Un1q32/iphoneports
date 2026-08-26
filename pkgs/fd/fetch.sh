#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.5.0'
if [ ! -f "$_DLCACHE/fd-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/fd-$ver.tar.gz" | awk '{print $1}')" != "e6d9e90730bf316101691e49d59cc02565278dc3779d33a77423801569484851" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/fd-$ver.tar.gz" "https://github.com/sharkdp/fd/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/fd-$ver.tar.gz"
mv "$_TMP"/fd-* "$_SRCDIR"
