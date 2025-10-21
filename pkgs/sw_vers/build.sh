#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_TARGET-cc" sw_vers.c -o sw_vers -Os -flto -framework CoreFoundation
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp sw_vers "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign sw_vers
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
