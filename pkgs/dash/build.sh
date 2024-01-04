#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip bin/dash
ldid -S"$_ENT" bin/dash
ln -s dash bin/sh
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg dash.deb
