#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='10.3p1'
if [ ! -f "$_DLCACHE/openssh-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/openssh-$ver.tar.gz" | awk '{print $1}')" != "56682a36bb92dcf4b4f016fd8ec8e74059b79a8de25c15d670d731e7d18e45f4" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/openssh-$ver.tar.gz" "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/openssh-$ver.tar.gz"
mv "$_TMP"/openssh-* "$_SRCDIR"
