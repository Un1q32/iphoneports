#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.15.4'
if [ ! -f "$_DLCACHE/libxml2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libxml2-$ver.tar.xz" | awk '{print $1}')" != "98087fd181d9070724f3fbc65c7377db03038eb92bd882374daff44940138821" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libxml2-$ver.tar.xz" "https://download.gnome.org/sources/libxml2/${ver%.*}/libxml2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libxml2-$ver.tar.xz"
mv "$_TMP"/libxml2-* "$_SRCDIR"
