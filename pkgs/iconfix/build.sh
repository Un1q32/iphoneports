#!/bin/sh
. ../../files/lib.sh

if [ "$_SUBSYSTEM" != "ios" ] ||
    { [ "$_SUBSYSTEM" = "ios" ] &&
    { [ "$_TRUEOSVER" -ge 70000 ] || [ "$_TRUEOSVER" -lt 20000 ]; }; }; then
    printf 'iconfix is for iOS 2 through 6\n'
    mkdir pkg
    exit 0
fi

mkdir -p "$_PKGROOT/pkg/usr/bin" "$_PKGROOT/pkg/usr/share/iconfix"
cp "$_PKGROOT/src/iconfix.sh" "$_PKGROOT/pkg/usr/bin/iconfix"
cp "$_PKGROOT"/src/*.png "$_PKGROOT/pkg/usr/share/iconfix"

builddeb
