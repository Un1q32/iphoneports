#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.54.0'
if [ ! -f "$_DLCACHE/git-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/git-$ver.tar.xz" | awk '{print $1}')" != "f689162364c10de79ef89aa8dbf48731eb057e34edbbd20aca510ce0154681a3" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/git-$ver.tar.xz" "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/git-$ver.tar.xz"
mv "$_TMP"/git-* "$_SRCDIR"
