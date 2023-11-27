#!/bin/sh

cp -a files/config.h files/Makefile.local src

(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" AR="$_TARGET-ar" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/demandoc bin/mandoc bin/soelim > /dev/null 2>&1
ldid -S"$_ENT" bin/demandoc bin/mandoc bin/soelim
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg mandoc.deb
