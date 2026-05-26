#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.3.2'
if [ ! -f "$_DLCACHE/libressl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libressl-$ver.tar.gz" | awk '{print $1}')" != "edf01aee24c65d69e6a9efcb9d44bcda682ff9d4f3bbbd95e794e1dfa90847b5" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libressl-$ver.tar.gz" "https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libressl-$ver.tar.gz"
mv "$_TMP"/libressl-* "$_SRCDIR"
