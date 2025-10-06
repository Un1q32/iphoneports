#!/bin/sh
rm -rf pkg src
ver='8.6'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/nano-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nano-$ver.tar.gz" | awk '{print $1}')" != "35acc088bc190943382b4da2752563d28cf31351c1478419c4c82908fba94456" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nano-$ver.tar.gz" "https://ftpmirror.gnu.org/gnu/nano/nano-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/nano-$ver.tar.gz"
mv nano-* src
