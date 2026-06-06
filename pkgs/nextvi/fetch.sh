#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='ebe9a97aa169b8d8863253edae615f104d13c22f'
if [ ! -f "$_DLCACHE/nextvi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nextvi-$ver.tar.gz" | awk '{print $1}')" != "d0e1cec60235898cd4b48ed5b7ab28846bcfa4fb0174d9b50c06021e244d38ef" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nextvi-$ver.tar.gz" "https://github.com/Un1q32/nextvi/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nextvi-$ver.tar.gz"
mv "$_TMP"/nextvi-* "$_SRCDIR"
