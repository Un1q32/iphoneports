#!/bin/sh -e
(
cd src
"$_MAKE" CC="$_TARGET-cc" STRIP=true CPP="$_TARGET-cc -E" DESTDIR="$_PKGROOT/pkg" prefix=/var/usr ENABLE_NLS= install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/dos2unix bin/unix2dos
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING.txt "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
