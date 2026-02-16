#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.8.12'
if [ ! -f "$_DLCACHE/gnutls-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/gnutls-$ver.tar.xz" | awk '{print $1}')" != "a7b341421bfd459acf7a374ca4af3b9e06608dcd7bd792b2bf470bea012b8e51" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gnutls-$ver.tar.xz" "https://www.gnupg.org/ftp/gcrypt/gnutls/v${ver%.*}/gnutls-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/gnutls-$ver.tar.xz"
mv "$_TMP"/gnutls-* "$_SRCDIR"
