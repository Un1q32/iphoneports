#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://github.com/ngtcp2/ngtcp2/releases/download/v1.15.1/ngtcp2-1.15.1.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv ngtcp2-* src
