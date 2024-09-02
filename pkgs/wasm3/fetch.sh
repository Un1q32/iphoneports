#!/bin/sh
commit=00b35a122bcc4e694016f281ce28651a7ec527c3
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/wasm3/wasm3/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "wasm3-${commit}" src
