#!/bin/sh
(
cd src || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" lib/usbmuxd > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/usbmuxd
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg usbmuxd.deb
