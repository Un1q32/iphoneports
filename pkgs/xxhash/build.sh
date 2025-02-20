#!/bin/sh -e
(
cd src
"$_MAKE" install UNAME=Darwin CC="$_TARGET-cc" AR="$_TARGET-ar" PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share lib/libxxhash.a
"$_TARGET-strip" bin/xxhsum lib/libxxhash.0.8.*.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/xxhsum lib/libxxhash.0.8.*.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "xxhash-$_DPKGARCH.deb"
