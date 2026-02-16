#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.6.55'
if [ ! -f "$_DLCACHE/libpng-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libpng-$ver.tar.xz" | awk '{print $1}')" != "d925722864837ad5ae2a82070d4b2e0603dc72af44bd457c3962298258b8e82d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libpng-$ver.tar.xz" "https://download.sourceforge.net/libpng/libpng-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libpng-$ver.tar.xz"
mv "$_TMP"/libpng-* "$_SRCDIR"
