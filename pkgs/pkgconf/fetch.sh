#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-2.5.1.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv pkgconf-pkgconf-* "$_SRCDIR"
