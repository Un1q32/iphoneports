#!/bin/sh -e
(
cd src
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static CPPFLAGS=-Wno-incompatible-function-pointer-types
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

(
cd pkg/var/usr/lib
"$_TARGET-strip" libuv.1.dylib 2>/dev/null || true
ldid -S"$_ENT" libuv.1.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
