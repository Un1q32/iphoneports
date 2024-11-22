#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://github.com/libusb/libusb/releases/download/v1.0.27/libusb-1.0.27.tar.bz2
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv libusb-* src

for src in emutls.c int_lib.h int_types.h int_endianness.h int_util.h; do
  curl -s -o "src/$src" "https://raw.githubusercontent.com/llvm/llvm-project/refs/tags/llvmorg-19.1.4/compiler-rt/lib/builtins/$src" &
done
wait
