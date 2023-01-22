#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.xz https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.xz
rm source.tar.xz
mv automake-1.16.5 source
