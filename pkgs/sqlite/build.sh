#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-static-shell --enable-silent-rules
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/sqlite3 lib/libsqlite3.0.dylib 2>/dev/null
ldid -S"$_ENT" bin/sqlite3 lib/libsqlite3.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg sqlite.deb
