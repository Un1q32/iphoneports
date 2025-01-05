#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share bin/psl-make-dafsa
"$_TARGET-strip" bin/psl lib/libpsl.5.dylib 2>/dev/null
ldid -S"$_ENT" bin/psl lib/libpsl.5.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libpsl.deb
