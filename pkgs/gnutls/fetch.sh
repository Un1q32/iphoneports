#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.8.11'
if [ ! -f "$_DLCACHE/gnutls-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/gnutls-$ver.tar.xz" | awk '{print $1}')" != "91bd23c4a86ebc6152e81303d20cf6ceaeb97bc8f84266d0faec6e29f17baa20" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gnutls-$ver.tar.xz" "https://www.gnupg.org/ftp/gcrypt/gnutls/v${ver%.*}/gnutls-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/gnutls-$ver.tar.xz"
mv "$_TMP"/gnutls-* "$_SRCDIR"
