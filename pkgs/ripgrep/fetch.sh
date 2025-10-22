#!/bin/sh
rm -rf pkg src
ver='15.1.0'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/ripgrep-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ripgrep-$ver.tar.gz" | awk '{print $1}')" != "e6b2d35ff79c3327edc0c92a29dc4bb74e82d8ee4b8156fb98e767678716be7a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ripgrep-$ver.tar.gz" "https://github.com/BurntSushi/ripgrep/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/ripgrep-$ver.tar.gz"
mv ripgrep-* src
