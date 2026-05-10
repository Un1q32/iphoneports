#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.61'
if [ ! -f "$_DLCACHE/libgpg-error-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/libgpg-error-$ver.tar.bz2" | awk '{print $1}')" != "7a85413f2bc354f4f8aa832b718af122e48965e9e0eb9012ee659c13c6385c93" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgpg-error-$ver.tar.bz2" "https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libgpg-error-$ver.tar.bz2"
mv "$_TMP"/libgpg-error-* "$_SRCDIR"
