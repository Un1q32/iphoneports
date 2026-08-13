#!/bin/sh
. ../../files/lib.sh

if [ "$_SUBSYSTEM" != "ios" ] || { [ "$_CPU" != 'arm64' ] && [ "$_CPU" != 'arm64e' ]; }; then
    printf 'rootless is only for arm64 iOS\n'
    mkdir "$_DESTDIR"
    exit 0
fi

mkdir -p "$_DESTDIR/var/jb/iphoneports"
ln -s jb/iphoneports "$_DESTDIR/var/usr"

builddeb
