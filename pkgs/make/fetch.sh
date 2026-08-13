#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.4.1'
if [ ! -f "$_DLCACHE/make-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/make-$ver.tar.gz" | awk '{print $1}')" != "dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/make-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/make/make-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/make-$ver.tar.gz"
mv "$_TMP"/make-* "$_SRCDIR"
