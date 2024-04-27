#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --without-cython --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" PACKAGE_VERSION=f2d3d40487a5209cb7dfae5367fb71f3940e3ab7 LIBS='-lusbmuxd-2.0 -limobiledevice-glue-1.0'
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip lib/libimobiledevice-1.0.6.dylib bin/*
ldid -S"$_ENT" lib/libimobiledevice-1.0.6.dylib bin/*
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libimobiledevice.deb
