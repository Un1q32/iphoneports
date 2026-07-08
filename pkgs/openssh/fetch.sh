#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.4p1'
if [ ! -f "$_DLCACHE/openssh-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssh-$ver.tar.gz" | awk '{print $1}')" != "ef6026dd2aea8d56059638d5d3262902c892ceba9f88395835e0d06d3fb63238" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssh-$ver.tar.gz" "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/openssh-$ver.tar.gz"
mv "$_TMP"/openssh-* "$_SRCDIR"
