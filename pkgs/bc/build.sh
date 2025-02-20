#!/bin/sh -e
(
cd src
CC="$_TARGET-cc" HOSTCC=cc ./configure --prefix=/var/usr --enable-readline --disable-nls --disable-strip --disable-man-pages
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" bc 2>/dev/null || true
ldid -S"$_ENT" bc
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "bc-$_DPKGARCH.deb"
