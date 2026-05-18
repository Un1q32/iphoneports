#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.5.13.4'
if [ ! -f "$_DLCACHE/dash-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/dash-$ver.tar.gz" | awk '{print $1}')" != "652e95024b75758dcd141b64a0d3973a026cc6aaee1aec81ce03e76dc3e6a267" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dash-$ver.tar.gz" "https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dash-$ver.tar.gz"
mv "$_TMP"/dash-* "$_SRCDIR"
