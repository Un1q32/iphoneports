#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://invisible-island.net/archives/lynx/tarballs/lynx2.9.2.tar.bz2
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.bz2
rm src.tar.bz2
mv "$_TMP"/lynx* "$_SRCDIR"
