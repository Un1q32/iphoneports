#!/bin/sh
rm -rf pkg src
ver='21.1.4'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "3a0921d78be74302cb054da1dad59e706814d8fed3a6ac9b532e935825a0715c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv llvm-project-llvmorg-* src
printf '%s\n' "${ver%%.*}" > src/iphoneports-llvmversion.txt
