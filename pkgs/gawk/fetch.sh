#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://ftp.gnu.org/gnu/gawk/gawk-5.2.1.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv gawk-5.2.1 source
