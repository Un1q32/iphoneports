#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.zst https://github.com/tukaani-project/xz/releases/download/v5.4.6/xz-5.4.6.tar.zst
printf "Unpacking source...\n"
tar -xf src.tar.zst
rm src.tar.zst
mv xz-5.4.6 src
