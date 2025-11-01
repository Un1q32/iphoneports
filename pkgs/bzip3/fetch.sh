#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.zst https://github.com/kspalaiologos/bzip3/releases/download/1.5.3/bzip3-1.5.3.tar.zst
printf "Unpacking source...\n"
tar -xf src.tar.zst
rm src.tar.zst
mv bzip3-* "$_SRCDIR"
