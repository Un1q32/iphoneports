#!/bin/sh
(
cd src || exit 1
"$_MAKE" CROSS_COMPILE="$_TARGET-" OS=Darwin -j8
"$_MAKE" CROSS_COMPILE="$_TARGET-" OS=Darwin PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/vi > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/vi
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nextvi.deb
