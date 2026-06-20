#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.8.2'
if [ ! -f "$_DLCACHE/jq-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/jq-$ver.tar.gz" | awk '{print $1}')" != "71b8d6e8f5fe81f6c6d0d110e3892251f6ce76ed095abd315e26e6e1193af3af" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/jq-$ver.tar.gz" "https://github.com/jqlang/jq/releases/download/jq-$ver/jq-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/jq-$ver.tar.gz"
mv "$_TMP"/jq-* "$_SRCDIR"
