#!/bin/sh
set -e
. ../../lib.sh
(
cd src
[ -d "$_SDK/usr/include/c++" ] && rm "$_SDK/var/usr/lib/libc++.dylib"
./configure --prefix=/var/usr CXX="$_TARGET-c++"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/lzip
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
[ -d "$_SDK/usr/include/c++" ] || sed -i -e '/^Depends:/ s/$/, iphoneports-libc++/' pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
