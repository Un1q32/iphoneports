#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.3.0'
if [ ! -f "$_DLCACHE/htop-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/htop-$ver.tar.gz" | awk '{print $1}')" != "1e5cc328eee2bd1acff89f860e3179ea24b85df3ac483433f92a29977b14b045" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/htop-$ver.tar.gz" "https://github.com/htop-dev/htop/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/htop-$ver.tar.gz"
mv "$_TMP"/htop-* "$_SRCDIR"
