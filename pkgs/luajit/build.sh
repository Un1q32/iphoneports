#!/bin/sh
(
cd src || exit 1
"$_MAKE" amalg TARGET_SYS=Darwin HOST_CC="gcc -m32" CROSS="$_TARGET-" BUILDMODE=dynamic CCOPT=-O3 PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_CFLAGS="-DLUAJIT_ENABLE_JIT" MACOSX_DEPLOYMENT_TARGET=10.6 -j"$_JOBS"
"$_MAKE" install PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_SYS=Darwin
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
ver="$(echo bin/luajit-2.1.*)"
ver="${ver#bin/luajit-2.1.}"
"$_TARGET-strip" "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib" 2>/dev/null
ldid -S"$_ENT" "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib"
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg luajit.deb
