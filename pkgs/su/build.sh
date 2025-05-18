#!/bin/sh
set -e
(
cd src
"$_TARGET-cc" -o su -Os -flto su.c -lpam
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp su "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign su
chmod 4755 su
)

mkdir -p pkg/usr/local/libexec/iphoneports pkg/var/usr/etc/pam.d
mv pkg/var/usr/bin/su pkg/usr/local/libexec/iphoneports/su
ln -s ../../../../usr/local/libexec/iphoneports/su pkg/var/usr/bin/su
cp files/su.pam pkg/var/usr/etc/pam.d/su

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
