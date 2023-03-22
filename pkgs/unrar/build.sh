#!/bin/sh
(
cd source || exit 1
"$_MAKE" CXX="$_TARGET-clang++" STRIP=true CXXFLAGS=-O2 LIBFLAGS= -j8
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" unrar "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/unrar > /dev/null 2>1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/unrar
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package unrar-6.2.6.deb
