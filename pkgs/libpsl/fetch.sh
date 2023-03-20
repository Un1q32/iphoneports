#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.lz https://github.com/rockdaboot/libpsl/releases/download/0.21.2/libpsl-0.21.2.tar.lz
printf "Unpacking source...\n"
tar -xf source.tar.lz
rm source.tar.lz
mv libpsl-0.21.2 source
