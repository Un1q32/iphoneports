#!/bin/sh
. ../../files/lib.sh

mkdir -p "$_DESTDIR/var/usr/bin"
cp "$_SRCDIR/pfetch" "$_DESTDIR/var/usr/bin"

mkdir -p "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"
cp "$_SRCDIR/LICENSE" "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"

builddeb
