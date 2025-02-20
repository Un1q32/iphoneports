#!/bin/sh -e
(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" lib/libpopt.0.dylib 2>/dev/null || true
ldid -S"$_ENT" lib/libpopt.0.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "popt-$_CPU-$_SUBSYSTEM.deb"
