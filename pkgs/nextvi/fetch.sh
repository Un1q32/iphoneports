#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='7fd998dc82fbbae5674706f08b02b22742debbfb'
if [ ! -f "$_DLCACHE/nextvi-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/nextvi-$ver.tar.gz" | awk '{print $1}')" != "0df6bc3f84b28e7e4663d93f7a67b5ed0bd2803ca741132250d76716129b2163" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/nextvi-$ver.tar.gz" "https://github.com/Un1q32/nextvi/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/nextvi-$ver.tar.gz"
mv "$_TMP"/nextvi-* "$_SRCDIR"
