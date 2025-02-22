#!/bin/sh -e
(
cd src
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/* lib/libpkgconf.5.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/* lib/libpkgconf.5.dylib
ln -s pkgconf bin/pkg-config
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg pkgconf.deb
