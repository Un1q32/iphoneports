#!/bin/sh
(
cd src || exit 1
"$_MAKE" TARGET_SYS=Darwin HOST_CC="gcc -m32" CROSS="$_TARGET-" CCOPT=-O2 PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_CFLAGS="-DLUAJIT_ENABLE_JIT" MACOSX_DEPLOYMENT_TARGET=10.5 install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share/man lib/libluajit-5.1.a
ln -sf luajit-2.1.0-beta3 bin/luajit
"$_TARGET-strip" bin/luajit-2.1.0-beta3 > /dev/null 2>&1
"$_TARGET-strip" lib/libluajit-5.1.2.1.0.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/luajit-2.1.0-beta3
ldid -S"$_BSROOT/ent.xml" lib/libluajit-5.1.2.1.0.dylib
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg luajit.deb
