#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_TARGET-cc" sysctl.c -o sysctl -Os -flto -D'__FBSDID(x)=' -w
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp sysctl "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign sysctl
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE-* "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
