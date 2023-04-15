#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.lz https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.13.tar.lz
printf "Unpacking source...\n"
tar -xf source.tar.lz
rm source.tar.lz
mv lzlib-1.13 source
