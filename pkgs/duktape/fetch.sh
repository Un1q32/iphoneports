#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://duktape.org/duktape-2.7.0.tar.xz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.xz
rm src.tar.xz
mv "$_TMP"/duktape-2.7.0 "$_SRCDIR"
