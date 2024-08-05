#!/bin/sh
commit=256cd37bbd654c6b3dc1f7523ebc651ee4a87989
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/wasm3/wasm3/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "wasm3-${commit}" src
