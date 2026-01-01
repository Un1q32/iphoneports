#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='6.6'
if [ ! -f "$_DLCACHE/ncurses-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ncurses-$ver.tar.gz" | awk '{print $1}')" != "355b4cbbed880b0381a04c46617b7656e362585d52e9cf84a67e2009b749ff11" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ncurses-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/ncurses/ncurses-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ncurses-$ver.tar.gz"
mv "$_TMP"/ncurses-* "$_SRCDIR"
