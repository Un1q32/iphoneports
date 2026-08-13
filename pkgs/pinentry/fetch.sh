#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.3.3'
if [ ! -f "$_DLCACHE/pinentry-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/pinentry-$ver.tar.gz" | awk '{print $1}')" != "36de9cf2fe819d9efbbd20d146a637b3a591a0d6d0a0604a396f37f1b77e5398" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pinentry-$ver.tar.gz" "https://github.com/gpg/pinentry/archive/refs/tags/pinentry-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/pinentry-$ver.tar.gz"
mv "$_TMP"/pinentry-* "$_SRCDIR"
