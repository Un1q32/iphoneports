#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://github.com/libimobiledevice/libplist/releases/download/2.7.0/libplist-2.7.0.tar.bz2
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.bz2
rm src.tar.bz2
mv "$_TMP"/libplist-* "$_SRCDIR"
