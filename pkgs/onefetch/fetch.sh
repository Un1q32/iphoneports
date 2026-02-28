#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.26.1'
if [ ! -f "$_DLCACHE/onefetch-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/onefetch-$ver.tar.gz" | awk '{print $1}')" != "ff43255d7c138c448cfdd1abacb01c6abe0c3e3886024e98ff077b28d4dc0ddc" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/onefetch-$ver.tar.gz" "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/onefetch-$ver.tar.gz"
mv "$_TMP"/onefetch-* "$_SRCDIR"
