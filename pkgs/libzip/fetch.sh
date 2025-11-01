#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://github.com/nih-at/libzip/releases/download/v1.11.4/libzip-1.11.4.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv libzip-* "$_SRCDIR"
