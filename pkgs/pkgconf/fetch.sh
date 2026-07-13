#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.0.1'
if [ ! -f "$_DLCACHE/pkgconf-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/pkgconf-$ver.tar.gz" | awk '{print $1}')" != "b65286de873153e7feab6d997c0b983e11f65f1fa79eeb4621584e7b10d05d9b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pkgconf-$ver.tar.gz" "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/pkgconf-$ver.tar.gz"
mv "$_TMP"/pkgconf-* "$_SRCDIR"
