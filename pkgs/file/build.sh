#!/bin/sh -e
(
cd src
./configure --prefix="$_PKGROOT/src/native"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install
"$_MAKE" clean
export PATH="$_PKGROOT/src/native/bin:$PATH"

./configure --host="$_TARGET" --prefix=/var/usr --enable-xzlib --enable-bzlib --enable-zlib --enable-zstdlib
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/man
strip_and_sign bin/file lib/libmagic.1.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
