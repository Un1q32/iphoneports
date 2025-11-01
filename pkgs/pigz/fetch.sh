#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://www.zlib.net/pigz/pigz-2.8.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv pigz-2.8 "$_SRCDIR"
