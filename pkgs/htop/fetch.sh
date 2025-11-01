#!/bin/sh -e
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/htop-dev/htop/archive/refs/tags/3.3.0.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv htop-* "$_SRCDIR"
