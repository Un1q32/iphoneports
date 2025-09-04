#!/bin/sh
rm -rf pkg src
ver='21.1.0'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "fba0618cf8de48ec05880c446edd756a2669157eab9d29949e971c77da10275f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-21.1.0.tar.gz
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv llvm-project-llvmorg-* src
