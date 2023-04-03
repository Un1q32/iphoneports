#!/bin/sh
rm -rf package source files/syntax
printf "Downloading source...\n"
curl -L -# -o source.tar.lz https://ftp.gnu.org/gnu/moe/moe-1.13.tar.lz
printf "Unpacking source...\n"
tar -xf source.tar.lz
rm source.tar.lz
mv moe-1.13 source
