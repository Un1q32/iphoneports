#!/bin/sh

[ "${0%/*}" = "$0" ] && bsroot="." || bsroot="${0%/*}"
cd "$bsroot" || exit 1
bsroot="$PWD"

if ! [ -f targets.txt ]; then
    printf 'No targets.txt file found!\n' >&2
    exit 1
fi

while IFS= read -r target; do
    ./build.sh --target="$target" "$@" || break
done < targets.txt
