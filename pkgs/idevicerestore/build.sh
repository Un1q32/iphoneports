#!/bin/sh
(
cd src || exit 1
./autogen.sh
bash ./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" PACKAGE_VERSION=e4a5ac4114177293e3a1b555ee767377b21d4432
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip bin/idevicerestore
ldid -S"$_ENT" bin/idevicerestore
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg idevicerestore.deb
