#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.xz https://ftp.gnu.org/gnu/coreutils/coreutils-9.3.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.xz
rm source.tar.xz
mv coreutils-9.3 source
