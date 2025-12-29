#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.25.0'
if [ ! -f "$_DLCACHE/onefetch-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/onefetch-$ver.tar.gz" | awk '{print $1}')" != "c9ade471eff5f57e5a6506a08293d8e7ebc54c27e99e33c965313a7108562f35" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/onefetch-$ver.tar.gz" "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/onefetch-$ver.tar.gz"
mv "$_TMP"/onefetch-* "$_SRCDIR"
