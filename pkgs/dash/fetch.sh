#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.5.12'
if [ ! -f "$_DLCACHE/dash-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/dash-$ver.tar.gz" | awk '{print $1}')" != "0d632f6b945058d84809cac7805326775bd60cb4a316907d0bd4228ff7107154" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dash-$ver.tar.gz" "https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dash-$ver.tar.gz"
mv "$_TMP"/dash-* "$_SRCDIR"
