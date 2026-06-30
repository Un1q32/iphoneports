#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3.2.0'
if [ ! -f "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" | awk '{print $1}')" != "980dd81f425082aa6d7c9e47fef27554ce7a9ffc8e2f6e863b97d263c5c50858" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libjpeg-turbo-$ver.tar.gz" "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libjpeg-turbo-$ver.tar.gz"
mv "$_TMP"/libjpeg-turbo-* "$_SRCDIR"
