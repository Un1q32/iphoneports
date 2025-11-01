#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://bellard.org/quickjs/quickjs-2024-01-13.tar.xz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.xz
rm src.tar.xz
mv "$_TMP"/quickjs-2024-01-13 "$_SRCDIR"
