#!/bin/sh -e
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv bison-* src
