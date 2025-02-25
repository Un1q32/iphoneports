#!/bin/sh -e
(
cd src
"$_MAKE" CXX="$_TARGET-c++" STRIP=true CXXFLAGS="-O3 -flto -Wno-dangling-else -Wno-switch" LIBFLAGS= -j"$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp unrar "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" unrar 2>/dev/null || true
ldid -S"$_ENT" unrar
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/license.txt "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
