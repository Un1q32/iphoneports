#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.4.8'
if [ ! -f "$_DLCACHE/gnupg-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/gnupg-$ver.tar.bz2" | awk '{print $1}')" != "b58c80d79b04d3243ff49c1c3fc6b5f83138eb3784689563bcdd060595318616" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gnupg-$ver.tar.bz2" "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/gnupg-$ver.tar.bz2"
mv gnupg-* "$_SRCDIR"
