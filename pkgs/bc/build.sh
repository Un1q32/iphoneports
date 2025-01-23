#!/bin/sh -e
(
cd src || exit 1
CC="$_TARGET-cc" HOSTCC=cc ./configure --prefix=/var/usr --enable-readline --disable-nls --disable-strip --disable-man-pages
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" bc 2>/dev/null || true
ldid -S"$_ENT" bc
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bc.deb
