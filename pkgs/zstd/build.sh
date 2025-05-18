#!/bin/sh -e
(
cd src
mkdir tmpbin
ln -s "$(command -v md5sum)" tmpbin/md5
export PATH="$PATH:$PWD/tmpbin"
"$_MAKE" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr UNAME=Darwin -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr UNAME=Darwin install
)

(
cd pkg/var/usr
rm -rf share lib/libzstd.a
strip_and_sign bin/zstd lib/libzstd.1.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
