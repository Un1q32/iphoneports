#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.4.4'
if [ ! -f "$_DLCACHE/rogue-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/rogue-$ver.tar.gz" | awk '{print $1}')" != "259cd9152fec3d9c5aa48975e6ee1a14b2f3aeb84fd31df57566cbb3c776d2b7" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/rogue-$ver.tar.gz" "https://github.com/Davidslv/rogue/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/rogue-$ver.tar.gz"
mv "$_TMP"/rogue-* "$_SRCDIR"
cp "$_BSROOT/files/gnu-config/"* "$_SRCDIR"
