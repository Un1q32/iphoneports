#!/bin/sh
set -e

[ "${0%/*}" = "$0" ] && scriptroot="." || scriptroot="${0%/*}"
cd "$scriptroot/.." || exit 1

rm -rf "target-bin/$_TRIPLE"
mkdir -p "target-bin/$_TRIPLE"

target="$_CPU-apple-darwin"
for bin in cctools-bin/*; do
	ln -s "../../$bin" "target-bin/$_TRIPLE/$target-${bin##*/}"
done
for cc in c++ gcc g++ clang clang++; do
	ln -s "$target-cc" "target-bin/$_TRIPLE/$target-$cc"
done
printf '%s\n' "$target"
