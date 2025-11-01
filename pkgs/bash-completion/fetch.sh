#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.17.0'
if [ ! -f "$_DLCACHE/bash-completion-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/bash-completion-$ver.tar.xz" | awk '{print $1}')" != "dd9d825e496435fb3beba3ae7bea9f77e821e894667d07431d1d4c8c570b9e58" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/bash-completion-$ver.tar.xz" "https://github.com/scop/bash-completion/releases/download/$ver/bash-completion-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/bash-completion-$ver.tar.xz"
mv bash-completion-* "$_SRCDIR"
