#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" lib/libimobiledevice-glue-1.0.0.dylib 2>/dev/null
ldid -S"$_ENT" lib/libimobiledevice-glue-1.0.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libimobiledevice-glue.deb
