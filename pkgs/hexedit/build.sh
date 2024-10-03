#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/hexedit 2>/dev/null
ldid -S"$_ENT" bin/hexedit
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg hexedit.deb
