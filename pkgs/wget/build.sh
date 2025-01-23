#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl=openssl --disable-iri
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/wget 2>/dev/null || true
ldid -S"$_ENT" bin/wget
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg wget.deb
