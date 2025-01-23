#!/bin/sh -e
(
cd src || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/ideviceactivation lib/libideviceactivation-1.0.2.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/ideviceactivation lib/libideviceactivation-1.0.2.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libideviceactivation.deb
