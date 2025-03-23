#!/bin/sh
commit=f7a74b59a8669524e4de1d2ea99365ec49e394b3
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/Un1q32/cctools-port/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "cctools-port-${commit}" src
