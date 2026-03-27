#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.1.4'
if [ ! -f "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" | awk '{print $1}')" != "3a581ad5a3060cee69487aae0bc71a1f3be94b89f92215e32b43742ec4a5055c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libjpeg-turbo-$ver.tar.gz"
mv "$_TMP"/libjpeg-turbo-* "$_SRCDIR"
