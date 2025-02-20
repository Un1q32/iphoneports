#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-udev --without-iokit PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
"$_TARGET-strip" bin/irecovery lib/libirecovery-1.0.5.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/irecovery lib/libirecovery-1.0.5.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "libirecovery-$_CPU-$_SUBSYSTEM.deb"
