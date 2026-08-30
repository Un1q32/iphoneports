#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.28.0'
if [ ! -f "$_DLCACHE/onefetch-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/onefetch-$ver.tar.gz" | awk '{print $1}')" != "b55047d224cbf42dbb06e140da4125269141c5a74eae76b712a8455c558ca8e1" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/onefetch-$ver.tar.gz" "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/onefetch-$ver.tar.gz"
mv "$_TMP"/onefetch-* "$_SRCDIR"
