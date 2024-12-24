#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://ffmpeg.org/releases/ffmpeg-7.1.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv ffmpeg-* src

for src in extendhfsf2.c truncsfhf2.c fp_extend_impl.inc fp_trunc_impl.inc fp_extend.h fp_trunc.h int_lib.h int_types.h int_endianness.h int_util.h; do
  curl -s -o "src/$src" "https://raw.githubusercontent.com/llvm/llvm-project/refs/tags/llvmorg-19.1.6/compiler-rt/lib/builtins/$src" &
done
wait
