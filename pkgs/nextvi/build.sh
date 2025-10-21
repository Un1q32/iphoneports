#!/bin/sh
set -e
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -std=c99 -Os -flto -D_POSIX_C_SOURCE=200809L -D_DARWIN_C_SOURCE vi.c -o vi
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vi "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/vi

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
