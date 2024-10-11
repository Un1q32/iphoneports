#!/bin/sh
commit=79d412ea5fcf92f0efe658d52827a0e0a96ff442
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/wasm3/wasm3/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "wasm3-${commit}" src
