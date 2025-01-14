#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static CPPFLAGS=-Wno-incompatible-function-pointer-types
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

(
cd pkg/var/usr/lib || exit 1
"$_TARGET-strip" libuv.1.dylib 2>/dev/null
ldid -S"$_ENT" libuv.1.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libuv.deb
