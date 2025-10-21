#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_TARGET-cc" -Os -flto -o pstree pstree.c
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pstree "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign pstree
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
