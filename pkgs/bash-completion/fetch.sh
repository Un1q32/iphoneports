#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.18.0'
if [ ! -f "$_DLCACHE/bash-completion-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/bash-completion-$ver.tar.xz" | awk '{print $1}')" != "88bcf85124f77f74f2f2f8bcd16ac4382d807a827ede742a64940c7116aea33f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/bash-completion-$ver.tar.xz" "https://github.com/scop/bash-completion/releases/download/$ver/bash-completion-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/bash-completion-$ver.tar.xz"
mv "$_TMP"/bash-completion-* "$_SRCDIR"
