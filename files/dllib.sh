#!/bin/sh

set -e

hashcheck() {
    ret=0
    { [ -f "$1" ] && [ "$(sha256sum "$1" | awk '{print $1}')" = "$2" ]; } || ret=1
    return $ret
}

dlsrc() {
    link="$1"
    cachename="$2"
    hash="$3"
    folder="$4"
    rm -rf "$_DESTDIR" "$_SRCDIR"
    if ! hashcheck "$_DLCACHE/$cachename" "$hash"; then
        printf "Downloading source...\n"
        tries=5
        while true; do
            if curl -L -# -o "$_DLCACHE/$cachename" "$link" && hashcheck "$_DLCACHE/$cachename" "$hash"; then
                break
            else
                tries=$((tries - 1))
                printf 'Failed to download file, tries remaining: %s\n' "$tries"
            fi
            if [ "$tries" -le 0 ]; then
                exit 1
            fi
        done
    fi
    printf "Unpacking source...\n"
    tar -C "$_TMP" -xf "$_DLCACHE/$cachename"
    mv "$_TMP/$folder" "$_SRCDIR"
}
