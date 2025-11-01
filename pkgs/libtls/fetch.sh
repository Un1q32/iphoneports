#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.2.1'
if [ ! -f "$_DLCACHE/libressl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libressl-$ver.tar.gz" | awk '{print $1}')" != "6d5c2f58583588ea791f4c8645004071d00dfa554a5bf788a006ca1eb5abd70b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libressl-$ver.tar.gz" "https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libressl-$ver.tar.gz"
mv "$_TMP"/libressl-* "$_SRCDIR"
