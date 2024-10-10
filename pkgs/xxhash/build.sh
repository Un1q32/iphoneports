#!/bin/sh
(
cd src || exit 1
"$_MAKE" install UNAME=Darwin CC="$_TARGET-cc" AR="$_TARGET-ar" PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share lib/libxxhash.a
"$_TARGET-strip" bin/xxhsum lib/libxxhash.0.8.2.dylib 2>/dev/null
ldid -S"$_ENT" bin/xxhsum lib/libxxhash.0.8.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xxhash.deb
