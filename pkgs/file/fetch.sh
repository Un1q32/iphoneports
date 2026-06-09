#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.48'
if [ ! -f "$_DLCACHE/file-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/file-$ver.tar.gz" | awk '{print $1}')" != "ed14656883b23a364b4057c05595d93252da9bc473d30106519519d0da141283" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/file-$ver.tar.gz" "ftp://ftp.astron.com/pub/file/file-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/file-$ver.tar.gz"
mv "$_TMP"/file-* "$_SRCDIR"
