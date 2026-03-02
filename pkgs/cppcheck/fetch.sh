#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.20.0'
if [ ! -f "$_DLCACHE/cppcheck-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cppcheck-$ver.tar.gz" | awk '{print $1}')" != "7be7992439339017edb551d8e7d2315f9bb57c402da50c2cee9cd0e2724600a1" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cppcheck-$ver.tar.gz" "https://github.com/danmar/cppcheck/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cppcheck-$ver.tar.gz"
mv "$_TMP"/cppcheck-* "$_SRCDIR"
