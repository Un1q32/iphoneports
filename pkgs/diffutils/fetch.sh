#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://ftpmirror.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv diffutils-* "$_SRCDIR"
