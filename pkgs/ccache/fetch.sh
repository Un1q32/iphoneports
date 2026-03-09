#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='4.13.1'
if [ ! -f "$_DLCACHE/ccache-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ccache-$ver.tar.gz" | awk '{print $1}')" != "28e875010d1d857c36ac83bf830565431b9f478626f1c3743da0cd4bd250452d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ccache-$ver.tar.gz" "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/ccache-$ver.tar.gz"
mv "$_TMP"/ccache-* "$_SRCDIR"
