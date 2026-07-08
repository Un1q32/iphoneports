#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='22.1.8'
if [ ! -f "$_DLCACHE/llvm-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/llvm-$ver.tar.gz" | awk '{print $1}')" != "ad18b70e287954c3d62bc7e0b86e7b7af2adf87bcfce21c15fe717f101d7aace" ]; then
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
