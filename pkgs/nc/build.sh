#!/bin/sh
set -e
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --enable-libtls-only --disable-static --enable-nc
"$_MAKE" -j"$_JOBS" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf etc share include lib
strip_and_sign bin/nc
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
