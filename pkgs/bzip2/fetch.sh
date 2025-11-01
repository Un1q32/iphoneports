#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.gz
rm src.tar.gz
mv "$_TMP"/bzip2-* "$_SRCDIR"
