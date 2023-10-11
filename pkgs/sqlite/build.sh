#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-static-shell=no
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/sqlite3 lib/libsqlite3.0.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/sqlite3 lib/libsqlite3.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg sqlite.deb
