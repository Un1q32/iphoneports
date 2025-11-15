#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='9.9'
if [ ! -f "$_DLCACHE/coreutils-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/coreutils-$ver.tar.xz" | awk '{print $1}')" != "19bcb6ca867183c57d77155eae946c5eced88183143b45ca51ad7d26c628ca75" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/coreutils-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/coreutils-$ver.tar.xz"
mv "$_TMP"/coreutils-* "$_SRCDIR"
