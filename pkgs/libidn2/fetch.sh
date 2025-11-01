#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://ftpmirror.gnu.org/gnu/libidn/libidn2-2.3.8.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv libidn2-* "$_SRCDIR"
