#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/info share/man share/doc
llvm-strip bin/nano
ldid -S"$_ENT" bin/nano
)

cp -a files/syntax/*.nanorc pkg/var/usr/share/nano
mkdir -p pkg/var/usr/etc
cp files/nanorc pkg/var/usr/etc

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nano.deb
