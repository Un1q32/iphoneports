#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.12'
if [ ! -f "$_DLCACHE/diffutils-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/diffutils-$ver.tar.xz" | awk '{print $1}')" != "7c8b7f9fc8609141fdea9cece85249d308624391ff61dedaf528fcb337727dfd" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/diffutils-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/diffutils/diffutils-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/diffutils-$ver.tar.xz"
mv "$_TMP"/diffutils-* "$_SRCDIR"
