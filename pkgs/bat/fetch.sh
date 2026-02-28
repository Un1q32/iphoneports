#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.26.1'
if [ ! -f "$_DLCACHE/bat-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/bat-$ver.tar.gz" | awk '{print $1}')" != "4474de87e084953eefc1120cf905a79f72bbbf85091e30cf37c9214eafcaa9c9" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/bat-$ver.tar.gz" "https://github.com/sharkdp/bat/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/bat-$ver.tar.gz"
mv "$_TMP"/bat-* "$_SRCDIR"
