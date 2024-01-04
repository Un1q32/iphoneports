#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-udev PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
llvm-strip bin/irecovery lib/libirecovery-1.0.3.dylib
ldid -S"$_ENT" bin/irecovery lib/libirecovery-1.0.3.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libirecovery.deb
