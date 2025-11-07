#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://sqlite.org/2025/sqlite-autoconf-3510000.tar.gz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.gz
rm src.tar.gz
mv "$_TMP"/sqlite-autoconf-* "$_SRCDIR"
