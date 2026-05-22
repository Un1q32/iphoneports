#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.9.4'
if [ ! -f "$_DLCACHE/libgit2-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libgit2-$ver.tar.gz" | awk '{print $1}')" != "824b73bd13647800fe4b566a1008ae77fea0e3e3424edab632fcfd8c0b14ba8b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgit2-$ver.tar.gz" "https://github.com/libgit2/libgit2/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libgit2-$ver.tar.gz"
mv "$_TMP"/libgit2-* "$_SRCDIR"
