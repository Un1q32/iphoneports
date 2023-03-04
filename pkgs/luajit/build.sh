#!/bin/sh
(
cd source || exit 1
"$_MAKE" TARGET_SYS=Darwin HOST_CC="gcc -m32" CROSS="$_TARGET-" CCOPT=-O2 PREFIX=/usr DESTDIR="$_PKGROOT/package" TARGET_CFLAGS="-DLUAJIT_ENABLE_JIT" MACOSX_DEPLOYMENT_TARGET=10.5 install -j8
)

(
cd package || exit 1
rm -rf usr/share/man
ln -sf luajit-2.1.0-beta3 usr/bin/luajit
"$_TARGET-strip" usr/bin/luajit-2.1.0-beta3
"$_TARGET-strip" -x usr/lib/libluajit-5.1.2.1.0.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/luajit-2.1.0-beta3
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libluajit-5.1.2.1.0.dylib
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package luajit-2.1.0-beta3.deb
