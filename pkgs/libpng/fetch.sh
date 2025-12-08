#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.6.53'
if [ ! -f "$_DLCACHE/libpng-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpng-$ver.tar.xz" | awk '{print $1}')" != "1d3fb8ccc2932d04aa3663e22ef5ef490244370f4e568d7850165068778d98d4" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpng-$ver.tar.xz" "https://download.sourceforge.net/libpng/libpng-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpng-$ver.tar.xz"
mv "$_TMP"/libpng-* "$_SRCDIR"
