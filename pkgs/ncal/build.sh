#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" ncal.c calendar.c easter.c -o ncal -lncurses -O2 -I. -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ncal "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ncal > /dev/null 2>&1
ldid -S"$_ENT" ncal
ln -s ncal cal
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncal.deb
