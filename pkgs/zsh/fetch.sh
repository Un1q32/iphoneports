#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.9.1'
if [ ! -f "$_DLCACHE/zsh-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/zsh-$ver.tar.gz" | awk '{print $1}')" != "5d20bec03f981dc4e9a09ec245e7415388ff641f79c5c5c416b5042e58d8280d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/zsh-$ver.tar.gz" "https://downloads.sourceforge.net/project/zsh/zsh/$ver/zsh-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/zsh-$ver.tar.gz"
mv "$_TMP"/zsh-* "$_SRCDIR"
