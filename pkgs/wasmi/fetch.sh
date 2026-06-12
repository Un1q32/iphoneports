#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.1.0'
if [ ! -f "$_DLCACHE/wasmi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wasmi-$ver.tar.gz" | awk '{print $1}')" != "08339285a8ed3302a7c90a878a24907841ebac70e00fee1cce48e97e69153d2e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wasmi-$ver.tar.gz" "https://github.com/wasmi-labs/wasmi/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/wasmi-$ver.tar.gz"
mv "$_TMP"/wasmi-* "$_SRCDIR"
