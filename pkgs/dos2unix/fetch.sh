#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7.5.7'
if [ ! -f "$_DLCACHE/dos2unix-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/dos2unix-$ver.tar.gz" | awk '{print $1}')" != "669ee27120ae71589f638fe3a167d6ea54f8633f5ab1b282551bd7a7c9510dfa" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dos2unix-$ver.tar.gz" "https://downloads.sourceforge.net/project/dos2unix/dos2unix/$ver/dos2unix-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dos2unix-$ver.tar.gz"
mv "$_TMP"/dos2unix-* "$_SRCDIR"
