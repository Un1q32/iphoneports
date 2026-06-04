#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.21.0'
if [ ! -f "$_DLCACHE/cppcheck-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cppcheck-$ver.tar.gz" | awk '{print $1}')" != "f028ff75ca5372738f3737c8b3e8611426a6526b6aea2ef01301ab0f5902f044" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cppcheck-$ver.tar.gz" "https://github.com/danmar/cppcheck/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cppcheck-$ver.tar.gz"
mv "$_TMP"/cppcheck-* "$_SRCDIR"
