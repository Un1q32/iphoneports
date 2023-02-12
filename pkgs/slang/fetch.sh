#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.bz2 https://www.jedsoft.org/releases/slang/slang-2.3.3.tar.bz2
printf "Unpacking source...\n"
tar -xf source.tar.bz2
rm source.tar.bz2
mv slang-2.3.3 source
