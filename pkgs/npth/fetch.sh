#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.8'
if [ ! -f "$_DLCACHE/npth-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/npth-$ver.tar.bz2" | awk '{print $1}')" != "8bd24b4f23a3065d6e5b26e98aba9ce783ea4fd781069c1b35d149694e90ca3e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/npth-$ver.tar.bz2" "https://gnupg.org/ftp/gcrypt/npth/npth-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/npth-$ver.tar.bz2"
mv "$_TMP"/npth-* "$_SRCDIR"
