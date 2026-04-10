#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='9.0'
if [ ! -f "$_DLCACHE/nano-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nano-$ver.tar.gz" | awk '{print $1}')" != "48a9cf0d021ddaf9d7b567ed30396147d4d2e3f7a32644f83257a7efead2b380" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nano-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/nano/nano-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nano-$ver.tar.gz"
mv "$_TMP"/nano-* "$_SRCDIR"
