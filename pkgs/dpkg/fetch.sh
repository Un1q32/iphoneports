#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.22.21'
if [ ! -f "$_DLCACHE/dpkg-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/dpkg-$ver.tar.bz2" | awk '{print $1}')" != "0b451c7b21c641b4c048f887f1d841c6c60a2b2a1501f744d6e2ab6b6c5295a2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dpkg-$ver.tar.bz2" "https://salsa.debian.org/dpkg-team/dpkg/-/archive/$ver/dpkg-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dpkg-$ver.tar.bz2"
mv "$_TMP"/dpkg-* "$_SRCDIR"
printf '%s\n' "$ver" > "$_SRCDIR/.dist-version"
