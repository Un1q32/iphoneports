#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" ncal.c calendar.c easter.c -o ncal -lncursesw -O2 -D__FBSDID=__RCSID -I.
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" ncal "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ncal > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" ncal
ln -s ncal cal
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncal.deb
