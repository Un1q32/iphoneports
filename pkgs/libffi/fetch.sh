#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.5.2'
if [ ! -f "$_DLCACHE/libffi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libffi-$ver.tar.gz" | awk '{print $1}')" != "f3a3082a23b37c293a4fcd1053147b371f2ff91fa7ea1b2a52e335676bac82dc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libffi-$ver.tar.gz" "https://github.com/libffi/libffi/releases/download/v$ver/libffi-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libffi-$ver.tar.gz"
mv "$_TMP"/libffi-* "$_SRCDIR"
