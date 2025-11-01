#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://ftpmirror.gnu.org/gnu/patch/patch-2.8.tar.xz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.xz
rm src.tar.xz
mv "$_TMP"/patch-* "$_SRCDIR"
