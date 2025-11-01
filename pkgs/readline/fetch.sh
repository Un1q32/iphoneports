#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='8.3'
if [ ! -f "$_DLCACHE/readline-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/readline-$ver.tar.gz" | awk '{print $1}')" != "fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/readline-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/readline/readline-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/readline-$ver.tar.gz"
mv "$_TMP"/readline-* "$_SRCDIR"
