#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.0.2'
if [ ! -f "$_DLCACHE/screen-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/screen-$ver.tar.gz" | awk '{print $1}')" != "ca9a2c7e240919bc7ac12124593ae4529bb4eb5f7349d8857829b7e3f0b3b332" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/screen-$ver.tar.gz" "https://ftp.gnu.org/gnu/screen/screen-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/screen-$ver.tar.gz"
mv "$_TMP"/screen-* "$_SRCDIR"
