#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.4.0'
if [ ! -f "$_DLCACHE/gawk-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/gawk-$ver.tar.xz" | awk '{print $1}')" != "3dd430f0cd3b4428c6c3f6afc021b9cd3c1f8c93f7a688dc268ca428a90b4ac1" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gawk-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/gawk/gawk-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/gawk-$ver.tar.xz"
mv "$_TMP"/gawk-* "$_SRCDIR"
