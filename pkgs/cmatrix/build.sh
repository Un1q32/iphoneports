#!/bin/sh -e
(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --without-fonts
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/cmatrix 2>/dev/null || true
ldid -S"$_ENT" bin/cmatrix
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "cmatrix-$_DPKGARCH.deb"
