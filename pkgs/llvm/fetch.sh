#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-20.1.8.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv llvm-project-llvmorg-* src
