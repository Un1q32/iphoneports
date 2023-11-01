#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-shell=/var/usr/bin/sh NCURSES_LIBS="-lncursesw"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/ncdu > /dev/null 2>&1
ldid -S"$_ENT" bin/ncdu
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncdu.deb
