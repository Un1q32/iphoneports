#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.52.0'
if [ ! -f "$_DLCACHE/git-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/git-$ver.tar.xz" | awk '{print $1}')" != "3cd8fee86f69a949cb610fee8cd9264e6873d07fa58411f6060b3d62729ed7c5" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/git-$ver.tar.xz" "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/git-$ver.tar.xz"
mv "$_TMP"/git-* "$_SRCDIR"
