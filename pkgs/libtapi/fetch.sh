#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='aa37c11ad1a817248c9d1578ac99e133875b4eb5'
if [ ! -f "$_DLCACHE/libtapi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libtapi-$ver.tar.gz" | awk '{print $1}')" != "3ea293da90789055e847af48582a46ff296fc6dfa4ef8ee8db3167599dd93da3" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libtapi-$ver.tar.gz" "https://github.com/tpoechtrager/apple-libtapi/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/libtapi-$ver.tar.gz"
mv apple-libtapi-* "$_SRCDIR"
