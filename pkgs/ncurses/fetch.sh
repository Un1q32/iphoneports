#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='6.5'
if [ ! -f "$_DLCACHE/ncurses-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ncurses-$ver.tar.gz" | awk '{print $1}')" != "136d91bc269a9a5785e5f9e980bc76ab57428f604ce3e5a5a90cebc767971cc6" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ncurses-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/ncurses/ncurses-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/ncurses-$ver.tar.gz"
mv ncurses-* "$_SRCDIR"
