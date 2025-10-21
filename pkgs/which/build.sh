#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_TARGET-cc" -Os -flto which.c -o which -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp which "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign which
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
