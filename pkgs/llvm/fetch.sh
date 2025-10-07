#!/bin/sh
rm -rf pkg src
ver='21.1.3'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "5bc91fe86bafebc64189465faca1ff35626dcb1b8539a14ae2ec07834c3e8e95" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv llvm-project-llvmorg-* src
printf '%s\n' "${ver%%.*}" > src/iphoneports-llvmversion.txt
