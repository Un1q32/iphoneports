#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='db5f7bad6e3a8e26936bc91e69791bc7b5ef6407'
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "4a84b917391a42be69d7e1beb93ee608396aaecf59f3c51ae1f18839b7f8c478" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv "$_TMP"/cctools-port-* "$_SRCDIR"
