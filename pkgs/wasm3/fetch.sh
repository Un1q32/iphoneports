#!/bin/sh
commit=139076a98b8321b67f850a844f558b5e91b5ac83
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/wasm3/wasm3/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "wasm3-${commit}" src
