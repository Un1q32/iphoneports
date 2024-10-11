#!/bin/sh

"$_TARGET-cc" -O3 -c -o src/compat.o files/compat.c

(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static CPPFLAGS=-Wno-incompatible-function-pointer-types LIBS="$_PKGROOT/src/compat.o"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/lib || exit 1
"$_TARGET-strip" libuv.1.dylib 2>/dev/null
ldid -S"$_ENT" libuv.1.dylib
sed -i "/compat.o/c\Libs: -L\${libdir} -luv" pkgconfig/libuv.pc
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libuv.deb
