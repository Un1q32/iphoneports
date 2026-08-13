#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.2.2'
if [ ! -f "$_DLCACHE/mpfr-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/mpfr-$ver.tar.xz" | awk '{print $1}')" != "b67ba0383ef7e8a8563734e2e889ef5ec3c3b898a01d00fa0a6869ad81c6ce01" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/mpfr-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/mpfr/mpfr-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/mpfr-$ver.tar.xz"
mv "$_TMP"/mpfr-* "$_SRCDIR"
