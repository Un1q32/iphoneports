#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.4.3'
if [ ! -f "$_DLCACHE/rsync-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/rsync-$ver.tar.gz" | awk '{print $1}')" != "c72e63ca3021cbc80ba86ec30102773f4c5631fbc492b52e773b3958f82a53d3" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/rsync-$ver.tar.gz" "https://download.samba.org/pub/rsync/src/rsync-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/rsync-$ver.tar.gz"
mv "$_TMP"/rsync-* "$_SRCDIR"
