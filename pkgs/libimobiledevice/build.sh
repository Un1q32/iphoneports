#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --without-cython --with-mbedtls --disable-static PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/* > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/*
"$_TARGET-strip" lib/libimobiledevice-1.0.6.0.0.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libimobiledevice-1.0.6.0.0.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libimobiledevice.deb
