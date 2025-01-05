#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/bzip3 lib/libbzip3.0.dylib 2>/dev/null
ldid -S"$_ENT" bin/bzip3 lib/libbzip3.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bzip3.deb
