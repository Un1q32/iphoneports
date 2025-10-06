#!/bin/sh
rm -rf pkg src
ver='21.1.2'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "eced3dd78186621f4df8a1accbcd1ecf2ee399571e62d052c21e9bf363af2166" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv llvm-project-llvmorg-* src
printf '%s\n' "${ver%%.*}" > src/iphoneports-llvmversion.txt
