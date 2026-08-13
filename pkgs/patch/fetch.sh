#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.8'
if [ ! -f "$_DLCACHE/patch-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/patch-$ver.tar.xz" | awk '{print $1}')" != "f87cee69eec2b4fcbf60a396b030ad6aa3415f192aa5f7ee84cad5e11f7f5ae3" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/patch-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/patch/patch-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/patch-$ver.tar.xz"
mv "$_TMP"/patch-* "$_SRCDIR"
