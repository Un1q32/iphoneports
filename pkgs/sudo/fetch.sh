#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.9.17p2'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/sudo-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/sudo-$ver.tar.gz" | awk '{print $1}')" != "4a38a1ab3adb1199257edc2a7c4a2bd714665eb605b04368843b06dada2cfcfb" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/sudo-$ver.tar.gz" "https://www.sudo.ws/dist/sudo-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/sudo-$ver.tar.gz"
mv sudo-* "$_SRCDIR"
