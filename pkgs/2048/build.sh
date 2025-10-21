#!/bin/sh
set -e
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -std=c99 -Os -flto -o 2048 2048.c
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp 2048 "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/2048

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
