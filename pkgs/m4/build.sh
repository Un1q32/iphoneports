#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/m4 2>/dev/null || true
ldid -S"$_ENT" bin/m4
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg m4.deb
