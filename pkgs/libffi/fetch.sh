#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/libffi/libffi/releases/download/v3.5.2/libffi-3.5.2.tar.gz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.gz
rm src.tar.gz
mv "$_TMP"/libffi-* "$_SRCDIR"
