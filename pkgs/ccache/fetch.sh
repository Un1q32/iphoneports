#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.13.5'
if [ ! -f "$_DLCACHE/ccache-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ccache-$ver.tar.gz" | awk '{print $1}')" != "99478c1b55b9c097baceef4cc559931bd2aff8dd43920df1a8cbb7445f23d1f1" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ccache-$ver.tar.gz" "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ccache-$ver.tar.gz"
mv "$_TMP"/ccache-* "$_SRCDIR"
