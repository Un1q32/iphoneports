#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
llvmver='20.1.1'
mkdir src && cd src || exit 1
curl -L -# -o src.tar.xz "https://github.com/llvm/llvm-project/releases/download/llvmorg-$llvmver/compiler-rt-$llvmver.src.tar.xz"
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv compiler-rt-* compiler-rt
printf '%s\n' "${llvmver%%.*}" > iphoneports-llvmversion.txt
