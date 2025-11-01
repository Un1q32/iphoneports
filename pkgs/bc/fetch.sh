#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://github.com/gavinhoward/bc/releases/download/7.0.3/bc-7.0.3.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv bc-* "$_SRCDIR"
