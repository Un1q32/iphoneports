#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='21.1.5'
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "297b35033b84da7c1214b05f901e154c1d7febe8fe51ecdbf27b0d0f9531902f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv "$_TMP"/llvm-project-llvmorg-* "$_SRCDIR"
printf '%s\n' "${ver%%.*}" > "$_SRCDIR/iphoneports-llvmversion.txt"
