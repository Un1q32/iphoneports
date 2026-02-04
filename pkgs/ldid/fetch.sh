#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='c50e84e18532044b23ec5e971d55ab0cdd4b6685'
if [ ! -f "$_DLCACHE/ldid-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ldid-$ver.tar.gz" | awk '{print $1}')" != "53d1523f2bbce36eefbec0c8c1764c0595ca8ad63e2c83264ae181f8eccf392b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ldid-$ver.tar.gz" "https://github.com/ProcursusTeam/ldid/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ldid-$ver.tar.gz"
mv "$_TMP"/ldid-* "$_SRCDIR"
