#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.57'
if [ ! -f "$_DLCACHE/libgpg-error-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/libgpg-error-$ver.tar.bz2" | awk '{print $1}')" != "ab807c81fbd2b8e1d6e3377383be802147c08818f87a82e87f85e5939c939def" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgpg-error-$ver.tar.bz2" "https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libgpg-error-$ver.tar.bz2"
mv "$_TMP"/libgpg-error-* "$_SRCDIR"
