#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.0.2'
if [ ! -f "$_DLCACHE/pkgconf-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/pkgconf-$ver.tar.gz" | awk '{print $1}')" != "99825df13c73d31cc3cd4687141e05f8cbe227ddbd4034ce6df3727c243e0794" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pkgconf-$ver.tar.gz" "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/pkgconf-$ver.tar.gz"
mv "$_TMP"/pkgconf-* "$_SRCDIR"
