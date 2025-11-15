#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='12e2486bc81c3b2be975d3e117a9d3ab6ec3970c'
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "791714a4eeb3ff8f1017ba634936366f33634296eb37dcb1699b058bd34b44c1" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv "$_TMP"/cctools-port-* "$_SRCDIR"
