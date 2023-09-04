#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl=openssl --disable-iri
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/wget > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/wget
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg wget.deb
