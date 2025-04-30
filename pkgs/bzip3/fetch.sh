#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.zst https://github.com/kspalaiologos/bzip3/releases/download/1.5.2/bzip3-1.5.2.tar.zst
printf "Unpacking source...\n"
tar -xf src.tar.zst
rm src.tar.zst
mv bzip3-* src
