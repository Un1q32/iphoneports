#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.8.0'
if [ ! -f "$_DLCACHE/libksba-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libksba-$ver.tar.gz" | awk '{print $1}')" != "1ad54e817b85d5a4b0f846a55a762cb086f40681e96e41f410ca88d62148fd3c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libksba-$ver.tar.gz" "https://github.com/gpg/libksba/archive/refs/tags/libksba-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libksba-$ver.tar.gz"
mv "$_TMP"/libksba-* "$_SRCDIR"
