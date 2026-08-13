#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.8'
if [ ! -f "$_DLCACHE/npth-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/npth-$ver.tar.gz" | awk '{print $1}')" != "39baf403b0d63271b31a7546a480b4570a422465823f82d93bcdd9c1491df5af" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/npth-$ver.tar.gz" "https://github.com/gpg/npth/archive/refs/tags/npth-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/npth-$ver.tar.gz"
mv "$_TMP"/npth-* "$_SRCDIR"
