#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl=openssl --with-openssl --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share bin/wget2_noinstall
llvm-strip bin/wget2 lib/libwget.2.dylib
ldid -S"$_ENT" bin/wget2 lib/libwget.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg wget2.deb
