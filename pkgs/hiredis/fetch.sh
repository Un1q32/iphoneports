#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.4.0'
if [ ! -f "$_DLCACHE/hiredis-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/hiredis-$ver.tar.gz" | awk '{print $1}')" != "5fa6e719e59cd4f8ae435c52a18ac4035d135251f9ee54e7a045bccf59107ed8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/hiredis-$ver.tar.gz" "https://github.com/redis/hiredis/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/hiredis-$ver.tar.gz"
mv "$_TMP"/hiredis-* "$_SRCDIR"
