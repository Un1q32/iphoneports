#!/bin/sh -e
(
cd src
"$_MAKE" PREFIX="$_PKGROOT/pkg/var/usr" CC="$_TARGET-cc" CFLAGS="-Os -flto -std=c99" install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf man
"$_TARGET-strip" bin/tree 2>/dev/null || true
ldid -S"$_ENT" bin/tree
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "tree-$_CPU-$_SUBSYSTEM.deb"
