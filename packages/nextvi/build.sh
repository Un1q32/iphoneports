#!/bin/sh
(
mkdir -p package/usr/bin
cd source || exit 1
"$_MAKE" CROSS_COMPILE="$_TARGET-" OS=Darwin PREFIX=/usr DESTDIR="$_PKGROOT/package" install -j8
)

(
cd package || exit 1
rm usr/bin/ex
ldid -S"$_BSROOT/ent.xml" usr/bin/vi
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nextvi.deb
