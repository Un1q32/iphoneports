#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/inetcat bin/iproxy lib/libusbmuxd-2.0.7.dylib 2>/dev/null
ldid -S"$_ENT" bin/inetcat bin/iproxy lib/libusbmuxd-2.0.7.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libusbmuxd.deb
