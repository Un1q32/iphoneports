#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.9.2'
if [ ! -f "$_DLCACHE/zsh-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/zsh-$ver.tar.gz" | awk '{print $1}')" != "36fa734374b44783582cec09bcd67822e2f992c779ec1624ab5596df078d2f81" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/zsh-$ver.tar.gz" "https://downloads.sourceforge.net/project/zsh/zsh/$ver/zsh-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/zsh-$ver.tar.gz"
mv "$_TMP"/zsh-* "$_SRCDIR"
cp "$_BSROOT/files/gnu-config/"* "$_SRCDIR"
