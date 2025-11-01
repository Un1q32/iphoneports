#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.51.2'
if [ ! -f "$_DLCACHE/git-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/git-$ver.tar.xz" | awk '{print $1}')" != "233d7143a2d58e60755eee9b76f559ec73ea2b3c297f5b503162ace95966b4e3" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/git-$ver.tar.xz" "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/git-$ver.tar.xz"
mv git-* "$_SRCDIR"
