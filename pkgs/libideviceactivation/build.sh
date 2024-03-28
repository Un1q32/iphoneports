#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" PACKAGE_VERSION=067c439e0b18d6f1c8a37dde791f9d91191a922e
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip bin/ideviceactivation lib/libideviceactivation-1.0.2.dylib
ldid -S"$_ENT" bin/ideviceactivation lib/libideviceactivation-1.0.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libideviceactivation.deb
