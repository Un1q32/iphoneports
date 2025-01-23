#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-assembler --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/* lib/libnettle.8.9.dylib lib/libhogweed.6.9.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/* lib/libnettle.8.9.dylib lib/libhogweed.6.9.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nettle.deb
