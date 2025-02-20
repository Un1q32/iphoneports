#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --program-prefix=g --disable-year2038 LIBS="-liconv"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/gtar 2>/dev/null || true
ldid -S"$_ENT" bin/gtar
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "gtar-$_DPKGARCH.deb"
