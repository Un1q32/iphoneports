#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.1.0'
if [ ! -f "$_DLCACHE/lpeg-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/lpeg-$ver.tar.gz" | awk '{print $1}')" != "4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/lpeg-$ver.tar.gz" "https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/lpeg-$ver.tar.gz"
mv "$_TMP"/lpeg-* "$_SRCDIR"
