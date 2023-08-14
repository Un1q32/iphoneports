#!/bin/sh
(
cd src || exit 1
"$_MAKE" CXX="$_TARGET-c++" STRIP=true CXXFLAGS=-O2 LIBFLAGS= -j8
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" unrar "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" unrar > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" unrar
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg unrar.deb
