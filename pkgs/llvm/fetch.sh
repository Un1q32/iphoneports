#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/llvm-project-19.1.2.src.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv llvm-project-* src
