#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.26'
if [ ! -f "$_DLCACHE/lzip-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/lzip-$ver.tar.gz" | awk '{print $1}')" != "641cf30961525cbe3b340cc883436c8854e9f5032f459f444de4782b621e6572" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/lzip-$ver.tar.gz" "https://download.savannah.nongnu.org/releases/lzip/lzip-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/lzip-$ver.tar.gz"
mv "$_TMP"/lzip-* "$_SRCDIR"
