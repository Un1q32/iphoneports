#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://ftp.gnu.org/gnu/diffutils/diffutils-3.9.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv diffutils-3.9 source
