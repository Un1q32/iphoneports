#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.5.21'
if [ ! -f "$_DLCACHE/gnupg-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/gnupg-$ver.tar.bz2" | awk '{print $1}')" != "e3af2c8caa46a66a9329fa7c6880af260451914d819595beabc2c26597b31352" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gnupg-$ver.tar.bz2" "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/gnupg-$ver.tar.bz2"
mv "$_TMP"/gnupg-* "$_SRCDIR"
