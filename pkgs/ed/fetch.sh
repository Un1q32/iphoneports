#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://ftp.gnu.org/gnu/ed/ed-1.18.tar.lz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv ed-1.18 source
