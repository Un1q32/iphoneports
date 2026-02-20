#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.59'
if [ ! -f "$_DLCACHE/libgpg-error-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/libgpg-error-$ver.tar.bz2" | awk '{print $1}')" != "a19bc5087fd97026d93cb4b45d51638d1a25202a5e1fbc3905799f424cfa6134" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgpg-error-$ver.tar.bz2" "https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libgpg-error-$ver.tar.bz2"
mv "$_TMP"/libgpg-error-* "$_SRCDIR"
