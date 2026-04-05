#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='fee8115127bb849d7481ea0015f181d3ebbd33cf'
if [ ! -f "$_DLCACHE/cctools-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/cctools-$ver.tar.gz" | awk '{print $1}')" != "7f5334412f3959335431f7e51ac7d1383472bbb98411c7d3914b94688bd66dff" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/cctools-$ver.tar.gz" "https://github.com/Un1q32/cctools-port/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/cctools-$ver.tar.gz"
mv "$_TMP"/cctools-port-* "$_SRCDIR"
