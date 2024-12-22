#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://www.python.org/ftp/python/3.13.1/Python-3.13.1.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv Python-* src

for src in emutls.c atomic.c int_lib.h int_types.h int_endianness.h int_util.h assembly.h; do
  curl -s -o "src/$src" "https://raw.githubusercontent.com/llvm/llvm-project/refs/tags/llvmorg-19.1.6/compiler-rt/lib/builtins/$src" &
done
wait
