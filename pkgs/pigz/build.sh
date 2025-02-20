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
"$_TARGET-strip" pigz 2>/dev/null || true
ldid -S"$_ENT" pigz
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "pigz-$_CPU-$_SUBSYSTEM.deb"
