#!/bin/sh -e
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://ftpmirror.gnu.org/gnu/bison/bison-3.8.2.tar.xz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.xz
rm src.tar.xz
mv "$_TMP"/bison-* "$_SRCDIR"
