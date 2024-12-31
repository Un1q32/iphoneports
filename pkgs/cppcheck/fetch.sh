#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/danmar/cppcheck/archive/refs/tags/2.16.0.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv cppcheck-* src

for src in emutls.c int_lib.h int_types.h int_endianness.h int_util.h; do
  curl -s -o "src/$src" "https://raw.githubusercontent.com/llvm/llvm-project/refs/tags/llvmorg-19.1.6/compiler-rt/lib/builtins/$src" &
done
wait
