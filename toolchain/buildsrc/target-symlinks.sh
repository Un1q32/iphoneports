#!/bin/sh
set -e

[ "${0%/*}" = "$0" ] && scriptroot="." || scriptroot="${0%/*}"
cd "$scriptroot/.." || exit 1

if [ -z "$_TRIPLE" ]; then
	printf 'Do not run this directly!\n'
	exit 1
fi

rm -rf "target-bin/$_TRIPLE"
mkdir -p "target-bin/$_TRIPLE"

target="$_CPU-apple-darwin"
for bin in cctools-bin/*; do
	ln -s "../../$bin" "target-bin/$_TRIPLE/$target-${bin##*/}"
done
for cc in c++ gcc g++ clang clang++; do
	ln -s "$target-cc" "target-bin/$_TRIPLE/$target-$cc"
done
ln -s "$target-ld" "target-bin/$_TRIPLE/$_TRIPLE-ld"
printf '%s\n' "$target"
