#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='9.1'
if [ ! -f "$_DLCACHE/nano-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nano-$ver.tar.gz" | awk '{print $1}')" != "2647a33f3c2ff3dc45168aeccff61abc7eae8bf99ac1d35574175c23bde6050b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nano-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/nano/nano-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nano-$ver.tar.gz"
mv "$_TMP"/nano-* "$_SRCDIR"
