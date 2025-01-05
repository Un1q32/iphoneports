#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-install-examples --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share bin
"$_TARGET-strip" lib/libhistory.8.2.dylib lib/libreadline.8.2.dylib 2>/dev/null
ldid -S"$_ENT" lib/libhistory.8.2.dylib lib/libreadline.8.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg readline.deb
