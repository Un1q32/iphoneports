#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='2.3.8'
if [ ! -f "$_DLCACHE/libidn2-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libidn2-$ver.tar.gz" | awk '{print $1}')" != "f557911bf6171621e1f72ff35f5b1825bb35b52ed45325dcdee931e5d3c0787a" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libidn2-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/libidn/libidn2-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libidn2-$ver.tar.gz"
mv "$_TMP"/libidn2-* "$_SRCDIR"
