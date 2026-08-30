#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.28.1'
if [ ! -f "$_DLCACHE/onefetch-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/onefetch-$ver.tar.gz" | awk '{print $1}')" != "d51e7411588b3aa8c4d747199941d93b8eb7878d8cfd605463a4c3da125b6be7" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/onefetch-$ver.tar.gz" "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/onefetch-$ver.tar.gz"
mv "$_TMP"/onefetch-* "$_SRCDIR"
