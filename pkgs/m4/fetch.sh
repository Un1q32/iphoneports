#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://ftpmirror.gnu.org/gnu/m4/m4-1.4.20.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv m4-* "$_SRCDIR"
