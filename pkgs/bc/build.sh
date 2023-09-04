#!/bin/sh
(
cd src || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/bc > /dev/null 2>&1
"$_TARGET-strip" bin/dc > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/bc
ldid -S"$_BSROOT/ent.xml" bin/dc
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bc.deb
