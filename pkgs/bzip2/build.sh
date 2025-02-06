#!/bin/sh -e
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf man
"$_TARGET-strip" bin/bzip2 bin/bzip2recover lib/libbz2.1.0.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/bzip2 bin/bzip2recover lib/libbz2.1.0.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "bzip2-$_DPKGARCH.deb"
