#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --enable-colors256 CPPFLAGS="-Wno-implicit-function-declaration"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/info share/man
"$_TARGET-strip" bin/screen-4.9.0 > /dev/null 2>&1
ldid -S"$_ENT" bin/screen-4.9.0
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg screen.deb
