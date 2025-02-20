#!/bin/sh -e
(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" sbin/usbmuxd 2>/dev/null || true
ldid -S"$_ENT" sbin/usbmuxd
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "usbmuxd-$_CPU-$_SUBSYSTEM.deb"
