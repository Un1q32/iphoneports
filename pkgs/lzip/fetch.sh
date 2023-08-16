#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.lz https://download.savannah.gnu.org/releases/lzip/lzip-1.23.tar.lz
printf "Unpacking source...\n"
tar -xf src.tar.lz
rm src.tar.lz
mv lzip-1.23 src
