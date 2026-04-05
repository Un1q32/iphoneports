#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='593d29141bf176d24021208c75af54a2ef23c38b'
if [ ! -f "$_DLCACHE/libtapi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libtapi-$ver.tar.gz" | awk '{print $1}')" != "dbad2a41f2351b052367db1fe251bebe43ee9ca5815e46b725c4bc71c339186f" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libtapi-$ver.tar.gz" "https://github.com/tpoechtrager/apple-libtapi/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libtapi-$ver.tar.gz"
mv "$_TMP"/apple-libtapi-* "$_SRCDIR"
