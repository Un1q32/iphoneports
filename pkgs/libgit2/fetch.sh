#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.9.2'
if [ ! -f "$_DLCACHE/libgit2-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libgit2-$ver.tar.gz" | awk '{print $1}')" != "6f097c82fc06ece4f40539fb17e9d41baf1a5a2fc26b1b8562d21b89bc355fe6" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgit2-$ver.tar.gz" "https://github.com/libgit2/libgit2/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libgit2-$ver.tar.gz"
mv "$_TMP"/libgit2-* "$_SRCDIR"
