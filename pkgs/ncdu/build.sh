#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-shell=/var/usr/bin/sh --enable-silent-rules PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/ncdu 2>/dev/null
ldid -S"$_ENT" bin/ncdu
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncdu.deb
