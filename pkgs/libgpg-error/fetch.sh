#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.55.tar.bz2
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv libgpg-error-* src
