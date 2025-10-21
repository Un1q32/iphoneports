#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_MAKE" CC="$_TARGET-cc"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pigz "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
ln -s pigz unpigz
strip_and_sign pigz
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
