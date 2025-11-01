#!/bin/sh
. ../../files/lib.sh

if ! { [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -ge 20000 ] && [ "$_OSVER" -lt 70000 ]; }; then
    printf 'iconfix is for iOS 2 through 6\n'
    mkdir "$_DESTDIR"
    exit 0
fi

mkdir -p "$_DESTDIR/usr/bin" "$_DESTDIR/usr/share/iconfix"
cp "$_SRCDIR/iconfix.sh" "$_DESTDIR/usr/bin/iconfix"
cp "$_SRCDIR"/*.png "$_DESTDIR/usr/share/iconfix"

builddeb
