#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
ver=5.8.1
curl -L -# -o src.tar.xz "https://github.com/tukaani-project/xz/releases/download/v$ver/xz-$ver.tar.xz"
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv xz-* src
