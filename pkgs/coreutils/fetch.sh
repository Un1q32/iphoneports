#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='9.10'
if [ ! -f "$_DLCACHE/coreutils-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/coreutils-$ver.tar.xz" | awk '{print $1}')" != "16535a9adf0b10037364e2d612aad3d9f4eca3a344949ced74d12faf4bd51d25" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/coreutils-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/coreutils-$ver.tar.xz"
mv "$_TMP"/coreutils-* "$_SRCDIR"
