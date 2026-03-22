#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.73'
if [ ! -f "$_DLCACHE/autoconf-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/autoconf-$ver.tar.xz" | awk '{print $1}')" != "9fd672b1c8425fac2fa67fa0477b990987268b90ff36d5f016dae57be0d6b52e" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/autoconf-$ver.tar.xz" "https://ftp.gnu.org/gnu/autoconf/autoconf-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/autoconf-$ver.tar.xz"
mv "$_TMP"/autoconf-* "$_SRCDIR"
