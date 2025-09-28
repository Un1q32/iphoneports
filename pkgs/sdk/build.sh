#!/bin/sh
set -e
. ../../files/lib.sh

mkdir -p pkg/var/usr/etc/profile.d
cp "$_PKGROOT/files/sdkroot.sh" pkg/var/usr/etc/profile.d
cp -a "$("$_TARGET-sdkpath")" pkg/var/usr/sdk

mkdir pkg/var/usr/sdk/usr/local
ln -s /var/usr/include pkg/var/usr/sdk/usr/local
ln -s /var/usr/lib pkg/var/usr/sdk/usr/local

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
