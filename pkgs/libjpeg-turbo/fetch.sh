#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/3.1.2.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv libjpeg-turbo-* "$_SRCDIR"
