#!/bin/sh

set -e

dlsrc() {
    link="$1"
    cachename="$2"
    hash="$3"
    folder="$4"
    rm -rf "$_DESTDIR" "$_SRCDIR"
    if [ ! -f "$_DLCACHE/$cachename" ] ||
        [ "$(sha256sum "$_DLCACHE/$cachename" | awk '{print $1}')" != "$hash" ]; then
        printf "Downloading source...\n"
        curl -L -# -o "$_DLCACHE/$cachename" "$link" || exit 1
    fi
    printf "Unpacking source...\n"
    tar -C "$_TMP" -xf "$_DLCACHE/$cachename"
    mv "$_TMP/$folder" "$_SRCDIR"
}
