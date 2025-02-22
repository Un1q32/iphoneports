#!/bin/sh -e
(
cd src
[ -d "$_SDK/usr/include/c++/4.2.1" ] && rm "$_SDK/var/usr/lib/libc++.dylib"
./configure --prefix=/var/usr CXX="$_TARGET-c++"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/lzip 2>/dev/null || true
ldid -S"$_ENT" bin/lzip
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
[ -d "$_SDK/usr/include/c++/4.2.1" ] || sed -i -e '/^Depends:/ s/$/, iphoneports-libc++/' pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg lzip.deb
