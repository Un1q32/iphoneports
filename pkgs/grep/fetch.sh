#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.12'
if [ ! -f "$_DLCACHE/grep-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/grep-$ver.tar.xz" | awk '{print $1}')" != "2649b27c0e90e632eadcd757be06c6e9a4f48d941de51e7c0f83ff76408a07b9" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/grep-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/grep/grep-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/grep-$ver.tar.xz"
mv "$_TMP"/grep-* "$_SRCDIR"
