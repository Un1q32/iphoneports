#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.2p1'
if [ ! -f "$_DLCACHE/openssh-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssh-$ver.tar.gz" | awk '{print $1}')" != "ccc42c0419937959263fa1dbd16dafc18c56b984c03562d2937ce56a60f798b2" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssh-$ver.tar.gz" "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/openssh-$ver.tar.gz"
mv "$_TMP"/openssh-* "$_SRCDIR"
