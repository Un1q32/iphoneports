#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.4.1'
if [ ! -f "$_DLCACHE/gawk-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/gawk-$ver.tar.xz" | awk '{print $1}')" != "07f6f7342b7febe4313fc2c2542ad93d64fe20ad8717200109f105a826f5fd37" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/gawk-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/gawk/gawk-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/gawk-$ver.tar.xz"
mv "$_TMP"/gawk-* "$_SRCDIR"
