#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
./configure --prefix=/var/usr
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
