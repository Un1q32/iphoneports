#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/Cyan4973/xxHash/archive/refs/tags/v0.8.3.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv xxHash-* "$_SRCDIR"
