#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" STRIP=true CPP="$_TARGET-cc -E" DESTDIR="$_PKGROOT/pkg" prefix=/var/usr ENABLE_NLS= install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/dos2unix > /dev/null 2>&1
"$_TARGET-strip" bin/unix2dos > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/dos2unix
ldid -S"$_BSROOT/ent.xml" bin/unix2dos
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg dos2unix.deb
