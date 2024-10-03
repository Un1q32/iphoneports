#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl=openssl --with-openssl --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share bin/wget2_noinstall
"$_TARGET-strip" bin/wget2 lib/libwget.2.dylib 2>/dev/null
ldid -S"$_ENT" bin/wget2 lib/libwget.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg wget2.deb
