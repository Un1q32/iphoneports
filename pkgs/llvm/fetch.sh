#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='23.1.0'
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "d8657b2a7291e518407bf13c4b41c85ef2cded2d4354097a2f451644dfc817b0" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/llvm-$ver.tar.gz" "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/llvm-$ver.tar.gz"
mv "$_TMP"/llvm-project-llvmorg-* "$_SRCDIR"
if [ "$_PKGNAME" = 'compiler-rt' ]; then
    printf '%s\n' "${ver%%.*}" > "$_SRCDIR/iphoneports-llvmversion.txt"
    ubsanver='4cede088a39199155ba8f7cb1844c46cbd912823'
    curl -L -s -o "$_SRCDIR/compiler-rt/ubsan.c" "https://raw.githubusercontent.com/Un1q32/ubsan/$ubsanver/ubsan.c" &
    curl -L -s -o "$_SRCDIR/compiler-rt/UBSAN-LICENSE" "https://raw.githubusercontent.com/Un1q32/ubsan/$ubsanver/LICENSE"
    wait
fi
