#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.11.0'
if [ ! -f "$_DLCACHE/findutils-$ver.tar.xz" ] ||
    [ "$(sha256sum "$_DLCACHE/findutils-$ver.tar.xz" | awk '{print $1}')" != "bfd19cb06cc71f3352d567e90284d8cdac02ac89774bbeadf0b533b0c11432fd" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/findutils-$ver.tar.xz" "https://ftpmirror.gnu.org/gnu/findutils/findutils-$ver.tar.xz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/findutils-$ver.tar.xz"
mv "$_TMP"/findutils-* "$_SRCDIR"
