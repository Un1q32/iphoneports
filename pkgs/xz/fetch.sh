#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://cytranet.dl.sourceforge.net/project/lzmautils/xz-5.4.4.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv xz-5.4.4 src
