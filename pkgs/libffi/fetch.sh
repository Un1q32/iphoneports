#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.7.1'
if [ ! -f "$_DLCACHE/libffi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libffi-$ver.tar.gz" | awk '{print $1}')" != "d5e9a6638ddbd2513ddb54518eb67e4bbe6fa707bcc01c10f6212f0a088d819d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libffi-$ver.tar.gz" "https://github.com/libffi/libffi/releases/download/v$ver/libffi-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libffi-$ver.tar.gz"
mv "$_TMP"/libffi-* "$_SRCDIR"
