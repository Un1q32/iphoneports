#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.0.9'
if [ ! -f "$_DLCACHE/wasmi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wasmi-$ver.tar.gz" | awk '{print $1}')" != "f72f76987dffd516e3a887118d4ea381f50803331f7ab5c75fc6b8b7da4d66b2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wasmi-$ver.tar.gz" "https://github.com/wasmi-labs/wasmi/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/wasmi-$ver.tar.gz"
mv "$_TMP"/wasmi-* "$_SRCDIR"
