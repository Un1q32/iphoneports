#!/bin/sh
set -e
. ../../lib.sh
(
cd src
"$_TARGET-cc" -dM -E - < /dev/null | grep -q __LP64__ && arg=-m64
"$_MAKE" amalg TARGET_SYS=Darwin HOST_CC="clang ${arg:--m32}" CROSS="$_TARGET-" BUILDMODE=dynamic CCOPT=-O3 PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_CFLAGS="-DLUAJIT_ENABLE_JIT" MACOSX_DEPLOYMENT_TARGET="$_MACVER" -j"$_JOBS"
"$_MAKE" install PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" TARGET_SYS=Darwin
)

(
cd pkg/var/usr
rm -rf share/man
ver="$(echo bin/luajit-2.1.*)"
ver="${ver#bin/luajit-2.1.}"
strip_and_sign "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib"
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYRIGHT "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
