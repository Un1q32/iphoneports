#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='a3259775afdb54419557994a5803c9b05a11450d'
if [ ! -f "$_DLCACHE/nextvi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nextvi-$ver.tar.gz" | awk '{print $1}')" != "ae435691010c39a21e7dc5ac389adbbb29dd2bf18d9c17d6db4a30b37e169a6b" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nextvi-$ver.tar.gz" "https://github.com/Un1q32/nextvi/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nextvi-$ver.tar.gz"
mv "$_TMP"/nextvi-* "$_SRCDIR"
