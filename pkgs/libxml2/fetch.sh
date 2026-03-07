#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.15.2'
if [ ! -f "$_DLCACHE/libxml2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libxml2-$ver.tar.xz" | awk '{print $1}')" != "c8b9bc81f8b590c33af8cc6c336dbff2f53409973588a351c95f1c621b13d09d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libxml2-$ver.tar.xz" "https://download.gnome.org/sources/libxml2/${ver%.*}/libxml2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libxml2-$ver.tar.xz"
mv "$_TMP"/libxml2-* "$_SRCDIR"
