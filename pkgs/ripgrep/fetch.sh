#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='15.1.0'
if [ ! -f "$_DLCACHE/ripgrep-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ripgrep-$ver.tar.gz" | awk '{print $1}')" != "e6b2d35ff79c3327edc0c92a29dc4bb74e82d8ee4b8156fb98e767678716be7a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ripgrep-$ver.tar.gz" "https://github.com/BurntSushi/ripgrep/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ripgrep-$ver.tar.gz"
mv "$_TMP"/ripgrep-* "$_SRCDIR"
