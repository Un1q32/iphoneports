#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://curl.se/download/curl-8.16.0.tar.xz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.xz
rm src.tar.xz
mv "$_TMP"/curl-* "$_SRCDIR"
