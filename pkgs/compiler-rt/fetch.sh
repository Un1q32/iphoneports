#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
llvmver='20.1.4'
curl -L -# -o src.tar.gz "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$llvmver.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv llvm-project-llvmorg-* src
printf '%s\n' "${llvmver%%.*}" > src/iphoneports-llvmversion.txt
