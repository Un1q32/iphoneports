#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.15.1'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/libxml2-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/libxml2-$ver.tar.xz" | awk '{print $1}')" != "c008bac08fd5c7b4a87f7b8a71f283fa581d80d80ff8d2efd3b26224c39bc54c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libxml2-$ver.tar.xz" "https://download.gnome.org/sources/libxml2/${ver%.*}/libxml2-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/libxml2-$ver.tar.xz"
mv libxml2-* "$_SRCDIR"
