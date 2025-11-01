#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.25.0'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/wget-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wget-$ver.tar.gz" | awk '{print $1}')" != "766e48423e79359ea31e41db9e5c289675947a7fcf2efdcedb726ac9d0da3784" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wget-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/wget/wget-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/wget-$ver.tar.gz"
mv wget-* "$_SRCDIR"
