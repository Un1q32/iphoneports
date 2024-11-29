#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.8.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv gnutls-* src

for src in emutls.c int_lib.h int_types.h int_endianness.h int_util.h; do
  curl -s -o "src/$src" "https://raw.githubusercontent.com/llvm/llvm-project/refs/tags/llvmorg-19.1.4/compiler-rt/lib/builtins/$src" &
done
wait
