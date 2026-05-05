#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.9.3'
if [ ! -f "$_DLCACHE/libgit2-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libgit2-$ver.tar.gz" | awk '{print $1}')" != "d532172d7ab24d2a25944e2434212d63ee85f3650e97b5f7579e7f201a78ad64" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libgit2-$ver.tar.gz" "https://github.com/libgit2/libgit2/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libgit2-$ver.tar.gz"
mv "$_TMP"/libgit2-* "$_SRCDIR"
