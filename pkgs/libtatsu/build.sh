#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/lib
"$_TARGET-strip" libtatsu.0.dylib 2>/dev/null || true
ldid -S"$_ENT" libtatsu.0.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "libtatsu-$_CPU-$_SUBSYSTEM.deb"
