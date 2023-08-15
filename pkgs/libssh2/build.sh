#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-examples-build --with-libz
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" lib/libssh2.1.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libssh2.1.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libssh2.deb