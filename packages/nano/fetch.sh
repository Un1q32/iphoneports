#!/bin/sh
rm -rf package source files/syntax
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://ftp.gnu.org/gnu/nano/nano-7.2.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv nano-7.2 source
git clone --depth 1 https://github.com/scopatz/nanorc.git files/syntax
