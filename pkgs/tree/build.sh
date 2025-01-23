#!/bin/sh -e
(
cd src || exit 1
"$_MAKE" PREFIX="$_PKGROOT/pkg/var/usr" CC="$_TARGET-cc" CFLAGS="-Os -flto -std=c99" install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf man
"$_TARGET-strip" bin/tree 2>/dev/null || true
ldid -S"$_ENT" bin/tree
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg tree.deb
