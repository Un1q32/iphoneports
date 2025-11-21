#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.18.1'
if [ ! -f "$_DLCACHE/automake-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/automake-$ver.tar.xz" | awk '{print $1}')" != "168aa363278351b89af56684448f525a5bce5079d0b6842bd910fdd3f1646887" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/automake-$ver.tar.xz" "https://ftp.gnu.org/gnu/automake/automake-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/automake-$ver.tar.xz"
mv "$_TMP"/automake-* "$_SRCDIR"
