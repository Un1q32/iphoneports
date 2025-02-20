#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-year2038
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share var
"$_TARGET-strip" bin/find bin/xargs bin/locate libexec/frcode 2>/dev/null || true
ldid -S"$_ENT" bin/find bin/xargs bin/locate libexec/frcode
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "findutils-$_DPKGARCH.deb"
