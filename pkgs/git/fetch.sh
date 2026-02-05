#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.53.0'
if [ ! -f "$_DLCACHE/git-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/git-$ver.tar.xz" | awk '{print $1}')" != "5818bd7d80b061bbbdfec8a433d609dc8818a05991f731ffc4a561e2ca18c653" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/git-$ver.tar.xz" "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/git-$ver.tar.xz"
mv "$_TMP"/git-* "$_SRCDIR"
