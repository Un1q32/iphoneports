#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='21.1.8'
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "7ba3f2a8d8fda88be18a31d011e8195d3b7f87f9fa92b20c94cba2d7f65b0e3f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv "$_TMP"/llvm-project-llvmorg-* "$_SRCDIR"
if [ "$_PKGNAME" = 'compiler-rt' ]; then
    printf '%s\n' "${ver%%.*}" > "$_SRCDIR/iphoneports-llvmversion.txt"
    ubsanver='5281153ae0e16862a5dba4c0defd4984665a4f34'
    curl -L -s -o "$_SRCDIR/compiler-rt/ubsan.c" "https://raw.githubusercontent.com/Un1q32/ubsan/$ubsanver/ubsan.c" &
    curl -L -s -o "$_SRCDIR/compiler-rt/UBSAN-LICENSE" "https://raw.githubusercontent.com/Un1q32/ubsan/$ubsanver/LICENSE"
    wait
fi
