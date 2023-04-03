#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.lz https://ftp.gnu.org/gnu/make/make-4.4.1.tar.lz
printf "Unpacking source...\n"
tar -xf source.tar.lz
rm source.tar.lz
mv make-4.4.1 source
