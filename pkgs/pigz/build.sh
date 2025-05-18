#!/bin/sh -e
(
cd src
"$_MAKE" CC="$_TARGET-cc"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pigz "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
ln -s pigz unpigz
strip_and_sign pigz
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
