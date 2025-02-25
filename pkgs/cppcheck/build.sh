#!/bin/sh -e
(
cd src
"$_MAKE" install CXX="$_TARGET-c++" PREFIX=/var/usr FILESDIR=/var/usr/share/cppcheck DESTDIR="$_PKGROOT/pkg" HAVE_RULES=yes uname_S=Darwin -j"$_JOBS"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" cppcheck 2>/dev/null || true
ldid -S"$_ENT" cppcheck
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
