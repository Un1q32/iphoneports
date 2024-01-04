#!/bin/sh
(
cd src || exit 1
"$_MAKE" PREFIX="$_PKGROOT/pkg/var/usr" CC="$_TARGET-cc" CFLAGS="-O2" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf man
llvm-strip bin/tree
ldid -S"$_ENT" bin/tree
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg tree.deb
