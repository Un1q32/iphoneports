#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.bz2 https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2
printf "Unpacking source...\n"
tar -xf source.tar.bz2
rm source.tar.bz2
mv gnupg-1.4.23 source
