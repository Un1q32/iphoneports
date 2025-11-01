#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.11.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv gnutls-* "$_SRCDIR"
