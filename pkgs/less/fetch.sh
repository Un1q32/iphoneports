#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='704'
if [ ! -f "$_DLCACHE/less-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/less-$ver.tar.gz" | awk '{print $1}')" != "20a0b0a2bb2525fa53c7eee9beb854b4c9cf172eabb209af7020743547bfe9fb" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/less-$ver.tar.gz" "https://www.greenwoodsoftware.com/less/less-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/less-$ver.tar.gz"
mv "$_TMP"/less-* "$_SRCDIR"
