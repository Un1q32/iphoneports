#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.xz https://cytranet.dl.sourceforge.net/project/lzmautils/xz-5.4.1.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.xz
rm source.tar.xz
mv xz-5.4.1 source
