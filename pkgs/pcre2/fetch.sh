#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.47'
if [ ! -f "$_DLCACHE/pcre2-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/pcre2-$ver.tar.bz2" | awk '{print $1}')" != "47fe8c99461250d42f89e6e8fdaeba9da057855d06eb7fc08d9ca03fd08d7bc7" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pcre2-$ver.tar.bz2" "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$ver/pcre2-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/pcre2-$ver.tar.bz2"
mv pcre2-* "$_SRCDIR"
