#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -std=c11 -O3 -flto -o tinyxxd main.c
mkdir -p "$_PKGROOT"/pkg/var/usr/bin
cp tinyxxd "$_PKGROOT"/pkg/var/usr/bin
)

(
cd "$_DESTDIR/var/usr/bin"
strip_and_sign tinyxxd
ln -s tinyxxd xxd
)

installlicense "$_SRCDIR/LICENSE"

builddeb
