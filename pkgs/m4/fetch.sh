#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.4.21'
if [ ! -f "$_DLCACHE/m4-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/m4-$ver.tar.gz" | awk '{print $1}')" != "38ae59f7a30bf9c108193cc5c25fbb06014f21e230c7ede2eff614f7b7c37ed8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/m4-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/m4/m4-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/m4-$ver.tar.gz"
mv "$_TMP"/m4-* "$_SRCDIR"
