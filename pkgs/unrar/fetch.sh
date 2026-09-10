#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.3.1'
if [ ! -f "$_DLCACHE/unrar-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/unrar-$ver.tar.gz" | awk '{print $1}')" != "634900842a3737d9cc15bbcc71d4c74cc713437e0bca296a573424fe5f2660ab" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/unrar-$ver.tar.gz" "https://www.rarlab.com/rar/unrarsrc-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/unrar-$ver.tar.gz"
mv "$_TMP/unrar" "$_SRCDIR"
