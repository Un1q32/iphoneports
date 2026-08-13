#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.8.2'
if [ ! -f "$_DLCACHE/bison-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/bison-$ver.tar.xz" | awk '{print $1}')" != "9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/bison-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/bison/bison-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/bison-$ver.tar.xz"
mv "$_TMP"/bison-* "$_SRCDIR"
