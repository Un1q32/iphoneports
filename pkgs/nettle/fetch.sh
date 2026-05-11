#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.0'
if [ ! -f "$_DLCACHE/nettle-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nettle-$ver.tar.gz" | awk '{print $1}')" != "3addbc00da01846b232fb3bc453538ea5468da43033f21bb345cb1e9073f5094" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nettle-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/nettle/nettle-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nettle-$ver.tar.gz"
mv "$_TMP"/nettle-* "$_SRCDIR"
