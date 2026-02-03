#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.3.1'
if [ ! -f "$_DLCACHE/tree-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/tree-$ver.tar.gz" | awk '{print $1}')" != "47ca786ed4ea4aa277cabd42b1a54635aca41b29e425e9229bd1317831f25665" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/tree-$ver.tar.gz" "https://oldmanprogrammer.net/tar/tree/tree-$ver.tgz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/tree-$ver.tar.gz"
mv "$_TMP"/tree-* "$_SRCDIR"
