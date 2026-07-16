#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='15.2.0'
if [ ! -f "$_DLCACHE/ripgrep-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ripgrep-$ver.tar.gz" | awk '{print $1}')" != "7605249d3eb0d5f170e3414498e3344e26b1e7a147aec518b57090b80036a562" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ripgrep-$ver.tar.gz" "https://github.com/BurntSushi/ripgrep/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ripgrep-$ver.tar.gz"
mv "$_TMP"/ripgrep-* "$_SRCDIR"
