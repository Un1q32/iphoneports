#!/bin/sh -e
(
cd src
"$_MAKE" CC="$_TARGET-cc" STRIP=true CPP="$_TARGET-cc -E" DESTDIR="$_PKGROOT/pkg" prefix=/var/usr ENABLE_NLS= install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/dos2unix bin/unix2dos 2>/dev/null || true
ldid -S"$_ENT" bin/dos2unix bin/unix2dos
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "dos2unix-$_CPU-$_SUBSYSTEM.deb"
