#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/inetcat bin/iproxy lib/libusbmuxd-2.0.6.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/inetcat bin/iproxy lib/libusbmuxd-2.0.6.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libusbmuxd.deb
