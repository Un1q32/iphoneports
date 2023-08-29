#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/lib || exit 1
"$_TARGET-strip" libimobiledevice-glue-1.0.0.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" libimobiledevice-glue-1.0.0.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libimobiledevice-glue.deb
