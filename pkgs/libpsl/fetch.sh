#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.lz https://github.com/rockdaboot/libpsl/releases/download/0.21.2/libpsl-0.21.2.tar.lz
printf "Unpacking source...\n"
tar -xf src.tar.lz
rm src.tar.lz
mv libpsl-0.21.2 src
