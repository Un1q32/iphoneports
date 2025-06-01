#!/bin/sh
set -e
. ../../lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --with-shell=/var/usr/bin/sh --enable-silent-rules PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

rm -rf pkg/var/usr/share
strip_and_sign pkg/var/usr/bin/ncdu

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
