#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.8.13'
if [ ! -f "$_DLCACHE/gnutls-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/gnutls-$ver.tar.xz" | awk '{print $1}')" != "ffed8ec1bf09c2426d4f14aae377de4753b53e537d685e604e99a8b16ca9c97e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gnutls-$ver.tar.xz" "https://www.gnupg.org/ftp/gcrypt/gnutls/v${ver%.*}/gnutls-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/gnutls-$ver.tar.xz"
mv "$_TMP"/gnutls-* "$_SRCDIR"
