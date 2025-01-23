#!/bin/sh -e
(
cd src || exit 1
"$_MAKE" CXX="$_TARGET-c++" STRIP=true CXXFLAGS="-O3 -flto -Wno-dangling-else -Wno-switch" LIBFLAGS= -j"$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp unrar "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" unrar 2>/dev/null || true
ldid -S"$_ENT" unrar
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg unrar.deb
