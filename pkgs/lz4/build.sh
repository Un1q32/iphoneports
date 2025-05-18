#!/bin/sh
set -e
(
cd src
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" BUILD_STATIC=no TARGET_OS=Darwin install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/lz4 lib/liblz4.1.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
