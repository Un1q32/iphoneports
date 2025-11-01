#!/bin/sh
. ../../files/lib.sh

if [ "$_SUBSYSTEM" != "ios" ] ||
    { [ "$_SUBSYSTEM" = "ios" ] &&
    { [ "$_TRUEOSVER" -ge 70000 ] || [ "$_TRUEOSVER" -lt 20000 ]; }; }; then
    printf 'iconfix is for iOS 2 through 6\n'
    mkdir pkg
    exit 0
fi

mkdir -p "$_DESTDIR/usr/bin" "$_DESTDIR/usr/share/iconfix"
cp "$_PKGROOT/src/iconfix.sh" "$_DESTDIR/usr/bin/iconfix"
cp "$_PKGROOT"/src/*.png "$_DESTDIR/usr/share/iconfix"

builddeb
