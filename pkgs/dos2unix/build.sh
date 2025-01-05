#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" STRIP=true CPP="$_TARGET-cc -E" DESTDIR="$_PKGROOT/pkg" prefix=/var/usr ENABLE_NLS= install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/dos2unix bin/unix2dos 2>/dev/null
ldid -S"$_ENT" bin/dos2unix bin/unix2dos
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg dos2unix.deb
