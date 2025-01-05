#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/lib || exit 1
"$_TARGET-strip" libtatsu.0.dylib 2>/dev/null
ldid -S"$_ENT" libtatsu.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libtatsu.deb
