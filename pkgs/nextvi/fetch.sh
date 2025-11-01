#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='ffc0710084719443b27fddad8d8c4fb9c1046b50'
if [ ! -f "$_DLCACHE/nextvi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nextvi-$ver.tar.gz" | awk '{print $1}')" != "84bd575d2e077d0e706ea3c6c1f36667f7b7b1a4b0597a679b7e8e0a7b5383ab" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nextvi-$ver.tar.gz" "https://github.com/Un1q32/nextvi/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nextvi-$ver.tar.gz"
mv "$_TMP"/nextvi-* "$_SRCDIR"
