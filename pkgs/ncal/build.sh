#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" ncal.c calendar.c easter.c -o ncal -lncursesw
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" ncal "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/ncal
ldid -S"$_BSROOT/ent.xml" bin/ncal
ln -s ncal bin/cal
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncal.deb
