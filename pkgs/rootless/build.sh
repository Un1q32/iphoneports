#!/bin/sh
. ../../files/lib.sh

if [ "$_SUBSYSTEM" = "macos" ] || { [ "$_CPU" != 'arm64' ] && [ "$_CPU" != 'arm64e' ]; }; then
    printf 'rootless is only for arm64 iOS/tvOS\n'
    mkdir "$_DESTDIR"
    exit 0
fi

mkdir -p "$_DESTDIR/var/jb/iphoneports"
ln -s jb/iphoneports "$_DESTDIR/var/usr"

builddeb
