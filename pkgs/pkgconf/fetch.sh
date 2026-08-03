#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.0.5'
if [ ! -f "$_DLCACHE/pkgconf-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/pkgconf-$ver.tar.gz" | awk '{print $1}')" != "245d441b9d8f7b74390e060cb9db1a326c26f1b96b1a6c3216b54a5d5439367a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/pkgconf-$ver.tar.gz" "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/pkgconf-$ver.tar.gz"
mv "$_TMP"/pkgconf-* "$_SRCDIR"
