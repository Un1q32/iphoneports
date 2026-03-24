#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.5.13.2'
if [ ! -f "$_DLCACHE/dash-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/dash-$ver.tar.gz" | awk '{print $1}')" != "ce88391bd79c71d9e182b005e69ebb11829e61ed6953276a086dad43701ac594" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/dash-$ver.tar.gz" "https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/dash-$ver.tar.gz"
mv "$_TMP"/dash-* "$_SRCDIR"
