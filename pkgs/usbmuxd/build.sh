#!/bin/sh -e
(
cd src || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" sbin/usbmuxd 2>/dev/null || true
ldid -S"$_ENT" sbin/usbmuxd
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg usbmuxd.deb
