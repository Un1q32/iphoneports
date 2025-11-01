#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='12.1.0'
if [ ! -f "$_DLCACHE/fmt-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/fmt-$ver.tar.gz" | awk '{print $1}')" != "ea7de4299689e12b6dddd392f9896f08fb0777ac7168897a244a6d6085043fea" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/fmt-$ver.tar.gz" "https://github.com/fmtlib/fmt/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/fmt-$ver.tar.gz"
mv fmt-* "$_SRCDIR"
