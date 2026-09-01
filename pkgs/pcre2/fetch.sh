#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.48'
if [ ! -f "$_DLCACHE/pcre2-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/pcre2-$ver.tar.bz2" | awk '{print $1}')" != "b6c68fdf6f3ac31388b50aa89ff0fc49c00c987c16e7b5146491d12003f2c8ed" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pcre2-$ver.tar.bz2" "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$ver/pcre2-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/pcre2-$ver.tar.bz2"
mv "$_TMP"/pcre2-* "$_SRCDIR"
