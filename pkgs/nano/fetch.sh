#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.7.1'
if [ ! -f "$_DLCACHE/nano-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nano-$ver.tar.gz" | awk '{print $1}')" != "f56b612024beb5900905a0580260434cf74a4dcdace8241608ff28ae2f472118" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nano-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/nano/nano-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nano-$ver.tar.gz"
mv "$_TMP"/nano-* "$_SRCDIR"
