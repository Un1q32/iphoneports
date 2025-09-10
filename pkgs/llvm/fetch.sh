#!/bin/sh
rm -rf pkg src
ver='21.1.1'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "5f048351ee63050d7fa45b6a1160768fb222a8d306a89e1344515ef7a4bcd278" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz"
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv llvm-project-llvmorg-* src
printf '%s\n' "${ver%%.*}" > src/iphoneports-llvmversion.txt
