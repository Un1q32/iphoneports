#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='21.1.7'
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "9ee167cdf8f6b5221d6b02dbe9a664cf8c6fee70fab071aaa4a3889c7c265258" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv "$_TMP"/llvm-project-llvmorg-* "$_SRCDIR"
printf '%s\n' "${ver%%.*}" > "$_SRCDIR/iphoneports-llvmversion.txt"
