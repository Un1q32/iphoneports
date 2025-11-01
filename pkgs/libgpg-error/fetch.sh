#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.56'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/libgpg-error-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/libgpg-error-$ver.tar.bz2" | awk '{print $1}')" != "82c3d2deb4ad96ad3925d6f9f124fe7205716055ab50e291116ef27975d169c0" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgpg-error-$ver.tar.bz2" "https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/libgpg-error-$ver.tar.bz2"
mv libgpg-error-* "$_SRCDIR"
