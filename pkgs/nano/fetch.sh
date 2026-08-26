#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='9.2'
if [ ! -f "$_DLCACHE/nano-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nano-$ver.tar.gz" | awk '{print $1}')" != "362d4cedbcefc20b4898382e325abf35cad00c2054a445b474260fff99bbbeb4" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nano-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/nano/nano-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nano-$ver.tar.gz"
mv "$_TMP"/nano-* "$_SRCDIR"
