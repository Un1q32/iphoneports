#!/bin/sh
(
cd src || exit 1
"$_MAKE" CXX="$_TARGET-c++" STRIP=true CXXFLAGS="-O2 -Wno-dangling-else -Wno-switch" LIBFLAGS= -j8
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp unrar "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip unrar
ldid -S"$_ENT" unrar
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg unrar.deb
