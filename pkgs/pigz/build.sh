#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pigz "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
ln -s pigz unpigz
llvm-strip pigz
ldid -S"$_ENT" pigz
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pigz.deb
