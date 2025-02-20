#!/bin/sh -e
(
cd src
[ -d "$_SDK/usr/include/c++/4.2.1" ] && rm "$_SDK/var/usr/lib/libc++.dylib"
./configure --host="$_TARGET" --prefix=/var/usr --without-cython --disable-static CC="$_TARGET-cc"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/plistutil lib/libplist-2.0.4.dylib lib/libplist++-2.0.4.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/plistutil lib/libplist-2.0.4.dylib lib/libplist++-2.0.4.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
[ -d "$_SDK/usr/include/c++/4.2.1" ] || sed -i -e '/^Depends:/ s/$/, iphoneports-libc++/' pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "libplist-$_DPKGARCH.deb"
