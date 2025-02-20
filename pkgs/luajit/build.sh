#!/bin/sh -e
(
cd src
clang="$(command -v "$_TARGET-sdkpath")"
clang="${clang%/*}/../share/iphoneports/bin/clang"
"$_TARGET-cc" -dM -E - < /dev/null | grep -q __LP64__ && arg=-m64
"$_MAKE" amalg TARGET_SYS=Darwin HOST_CC="$clang ${arg:--m32}" CROSS="$_TARGET-" BUILDMODE=dynamic CCOPT=-O3 PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_CFLAGS="-DLUAJIT_ENABLE_JIT" MACOSX_DEPLOYMENT_TARGET=10.5 -j"$_JOBS"
"$_MAKE" install PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_SYS=Darwin
)

(
cd pkg/var/usr
rm -rf share/man
ver="$(echo bin/luajit-2.1.*)"
ver="${ver#bin/luajit-2.1.}"
"$_TARGET-strip" "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib" 2>/dev/null || true
ldid -S"$_ENT" "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib"
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "luajit-$_CPU-$_SUBSYSTEM.deb"
