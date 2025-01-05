#!/bin/sh
(
cd src || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --without-fonts
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/cmatrix 2>/dev/null
ldid -S"$_ENT" bin/cmatrix
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg cmatrix.deb
