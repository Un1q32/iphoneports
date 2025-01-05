#!/bin/sh
(
cd src/build_unix || exit 1
../dist/configure --host="$_TARGET" --prefix=/var/usr --enable-cxx --enable-compat185 --disable-static --with-mutex=Darwin/_spin_lock_try CPPFLAGS='-Wno-deprecated-non-prototype'
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/* lib/libdb-6.2.dylib lib/libdb_cxx-6.2.dylib 2>/dev/null
ldid -S"$_ENT" bin/* lib/libdb-6.2.dylib lib/libdb_cxx-6.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg db.deb
