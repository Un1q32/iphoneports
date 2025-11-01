#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.2.tar.bz2
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv libassuan-* "$_SRCDIR"
