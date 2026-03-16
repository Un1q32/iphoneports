#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.22.22'
if [ ! -f "$_DLCACHE/dpkg-$ver.tar.bz2" ] ||
    [ "$(sha256sum "$_DLCACHE/dpkg-$ver.tar.bz2" | awk '{print $1}')" != "db48ad3a25d2afe11eeefcce0d0b24613ef1121eafa476a838eadabb8f43720e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dpkg-$ver.tar.bz2" "https://salsa.debian.org/dpkg-team/dpkg/-/archive/$ver/dpkg-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dpkg-$ver.tar.bz2"
mv "$_TMP"/dpkg-* "$_SRCDIR"
printf '%s\n' "$ver" > "$_SRCDIR/.dist-version"
