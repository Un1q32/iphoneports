#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static CC="$_TARGET-cc"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" lib/libmpfr.6.dylib 2>/dev/null || true
ldid -S"$_ENT" lib/libmpfr.6.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
