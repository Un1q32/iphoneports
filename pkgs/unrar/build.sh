#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_MAKE" CXX="$_TARGET-c++" STRIP=true CXXFLAGS="-O3 -flto -Wno-dangling-else -Wno-switch" LIBFLAGS= -j"$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp unrar "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign unrar
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/license.txt "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
