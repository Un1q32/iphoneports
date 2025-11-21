#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='6.2.32'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/db-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/db-$ver.tar.gz" | awk '{print $1}')" != "a9c5e2b004a5777aa03510cfe5cd766a4a3b777713406b02809c17c8e0e7a8fb" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/db-$ver.tar.gz" "https://download.oracle.com/berkeley-db/db-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/db-$ver.tar.gz"
mv "$_TMP"/db-* "$_SRCDIR"
