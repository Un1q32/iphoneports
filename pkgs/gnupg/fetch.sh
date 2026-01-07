#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.4.9'
if [ ! -f "$_DLCACHE/gnupg-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/gnupg-$ver.tar.bz2" | awk '{print $1}')" != "dd17ab2e9a04fd79d39d853f599cbc852062ddb9ab52a4ddeb4176fd8b302964" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gnupg-$ver.tar.bz2" "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/gnupg-$ver.tar.bz2"
mv "$_TMP"/gnupg-* "$_SRCDIR"
