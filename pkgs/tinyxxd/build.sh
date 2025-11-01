#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -std=c11 -O3 -flto -o tinyxxd main.c
mkdir -p "$_PKGROOT"/pkg/var/usr/bin
cp tinyxxd "$_PKGROOT"/pkg/var/usr/bin
)

strip_and_sign "$_DESTDIR/var/usr/bin/tinyxxd"
ln -s tinyxxd "$_DESTDIR/var/usr/bin/xxd"

installlicense "$_SRCDIR/LICENSE"

builddeb
