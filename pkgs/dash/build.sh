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
"$_TARGET-strip" bin/dash > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/dash
ln -s dash bin/sh
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg dash.deb
