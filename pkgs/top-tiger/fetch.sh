#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/apple-oss-distributions/top/archive/refs/tags/top-17.4.tar.gz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.gz
mv "$_TMP"/top-top-* "$_SRCDIR"
rm src.tar.gz
