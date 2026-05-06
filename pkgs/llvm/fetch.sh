#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='22.1.5'
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "263e99bd0b590664a886b0332037ff060e108f4e7b0310b7c8277208858f867d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv "$_TMP"/llvm-project-llvmorg-* "$_SRCDIR"
if [ "$_PKGNAME" = 'compiler-rt' ]; then
    printf '%s\n' "${ver%%.*}" > "$_SRCDIR/iphoneports-llvmversion.txt"
    ubsanver='2ebdd77d7da2a74657d05f6c27bf72f0258a0be4'
    curl -L -s -o "$_SRCDIR/compiler-rt/ubsan.c" "https://raw.githubusercontent.com/Un1q32/ubsan/$ubsanver/ubsan.c" &
    curl -L -s -o "$_SRCDIR/compiler-rt/UBSAN-LICENSE" "https://raw.githubusercontent.com/Un1q32/ubsan/$ubsanver/LICENSE"
    wait
fi
