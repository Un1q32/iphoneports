#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.47'
if [ ! -f "$_DLCACHE/file-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/file-$ver.tar.gz" | awk '{print $1}')" != "45672fec165cb4cc1358a2d76b5d57d22876dcb97ab169427ac385cbe1d5597a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/file-$ver.tar.gz" "ftp://ftp.astron.com/pub/file/file-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/file-$ver.tar.gz"
mv "$_TMP"/file-* "$_SRCDIR"
