#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='9.11'
if [ ! -f "$_DLCACHE/coreutils-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/coreutils-$ver.tar.xz" | awk '{print $1}')" != "394024eda0a5955217ceda9cd1201e65dc8fa3aa29c2951135a49521d57c3cc3" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/coreutils-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/coreutils-$ver.tar.xz"
mv "$_TMP"/coreutils-* "$_SRCDIR"
