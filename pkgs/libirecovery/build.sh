#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-udev PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/irecovery > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/irecovery
"$_TARGET-strip" lib/libirecovery-1.0.3.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libirecovery-1.0.3.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libirecovery.deb
