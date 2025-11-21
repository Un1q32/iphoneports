#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.72'
if [ ! -f "$_DLCACHE/autoconf-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/autoconf-$ver.tar.xz" | awk '{print $1}')" != "ba885c1319578d6c94d46e9b0dceb4014caafe2490e437a0dbca3f270a223f5a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/autoconf-$ver.tar.xz" "https://ftp.gnu.org/gnu/autoconf/autoconf-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/autoconf-$ver.tar.xz"
mv "$_TMP"/autoconf-* "$_SRCDIR"
