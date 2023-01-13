#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv m4-1.4.19 source
