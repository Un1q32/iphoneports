#!/bin/sh
(
cd src || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --without-fonts
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip bin/cmatrix
ldid -S"$_ENT" bin/cmatrix
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg cmatrix.deb
