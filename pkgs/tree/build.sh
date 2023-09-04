#!/bin/sh
(
cd src || exit 1
"$_MAKE" PREFIX="$_PKGROOT/pkg/var/usr" CC="$_TARGET-cc" CFLAGS="-O2" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf man
"$_TARGET-strip" bin/tree > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/tree
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg tree.deb
