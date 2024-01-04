#!/bin/sh
(
cd src || exit 1
"$_MAKE" amalg TARGET_SYS=Darwin HOST_CC="gcc -m32" CROSS="$_TARGET-" BUILDMODE=dynamic CCOPT=-O2 PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_CFLAGS="-DLUAJIT_ENABLE_JIT" MACOSX_DEPLOYMENT_TARGET=10.7 -j8
"$_MAKE" install PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_SYS=Darwin
)

(
cd pkg/var/usr || exit 1
rm -rf share/man
ver="$(echo bin/luajit-2.1.*)"
ver="${ver#bin/luajit-2.1.}"
llvm-strip "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib"
ldid -S"$_ENT" "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib"
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg luajit.deb
