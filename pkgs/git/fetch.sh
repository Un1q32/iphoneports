#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.55.0'
if [ ! -f "$_DLCACHE/git-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/git-$ver.tar.xz" | awk '{print $1}')" != "457fdb04dc8728e007d4688695e6912e6f680727920f2a40bf11eacc17505357" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/git-$ver.tar.xz" "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/git-$ver.tar.xz"
mv "$_TMP"/git-* "$_SRCDIR"
