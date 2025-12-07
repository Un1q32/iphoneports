#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.6.52'
if [ ! -f "$_DLCACHE/libpng-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpng-$ver.tar.xz" | awk '{print $1}')" != "36bd726228ec93a3b6c22fdb49e94a67b16f2fe9b39b78b7cb65772966661ccc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpng-$ver.tar.xz" "https://download.sourceforge.net/libpng/libpng-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpng-$ver.tar.xz"
mv "$_TMP"/libpng-* "$_SRCDIR"
