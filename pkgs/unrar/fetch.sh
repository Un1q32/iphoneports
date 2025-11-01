#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.1.10'
if [ ! -f "$_DLCACHE/unrar-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/unrar-$ver.tar.gz" | awk '{print $1}')" != "72a9ccca146174f41876e8b21ab27e973f039c6d10b13aabcb320e7055b9bb98" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/unrar-$ver.tar.gz" "https://www.rarlab.com/rar/unrarsrc-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/unrar-$ver.tar.gz"
mv "$_TMP/unrar" "$_SRCDIR"
