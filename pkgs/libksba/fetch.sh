#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.7.tar.bz2
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv libksba-* src
