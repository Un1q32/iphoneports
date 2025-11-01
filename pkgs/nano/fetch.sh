#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.6'
if [ ! -f "$_DLCACHE/nano-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nano-$ver.tar.gz" | awk '{print $1}')" != "86608f72b77787bf15dde922077c62a679aa4536192942991f58a92062838187" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nano-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/nano/nano-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nano-$ver.tar.gz"
mv "$_TMP"/nano-* "$_SRCDIR"
