#!/bin/sh
rm -rf pkg src
ver='2.51.2'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/git-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/git-$ver.tar.xz" | awk '{print $1}')" != "a83fd9ffaed7eee679ed92ceb06f75b4615ebf66d3ac4fbdbfbc9567dc533f4a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/git-$ver.tar.xz" "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/git-$ver.tar.xz"
mv git-* src
