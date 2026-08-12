#!/bin/sh
set -e

[ "${0%/*}" = "$0" ] && bsroot="." || bsroot="${0%/*}"
cd "$bsroot" || exit 1

for target in sdks/*; do
    ./build.sh --target="${target##*/}" "$@" || break
done
