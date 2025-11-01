#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://astron.com/pub/tcsh/tcsh-6.24.16.tar.gz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.gz
rm src.tar.gz
mv "$_TMP"/tcsh-* "$_SRCDIR"
