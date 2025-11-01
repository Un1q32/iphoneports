#!/bin/sh
. ../../files/lib.sh

(
cd src
make CXX="$_TARGET-c++" STRIP=true CXXFLAGS="-O3 -flto -Wno-dangling-else -Wno-switch" LIBFLAGS= -j"$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp unrar "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign unrar
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/license.txt "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
