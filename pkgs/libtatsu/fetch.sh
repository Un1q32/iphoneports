#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://github.com/libimobiledevice/libtatsu/releases/download/1.0.5/libtatsu-1.0.5.tar.bz2
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.bz2
rm src.tar.bz2
mv "$_TMP"/libtatsu-* "$_SRCDIR"
