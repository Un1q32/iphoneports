#!/bin/sh -e
(
cd src || exit 1
"$_TARGET-cc" -o su -Os -flto su.c -lpam
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp su "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" su 2>/dev/null || true
ldid -S"$_ENT" su
chmod 4755 su
)

mkdir -p pkg/usr/libexec/iphoneports pkg/var/usr/etc/pam.d
mv pkg/var/usr/bin/su pkg/usr/libexec/iphoneports/su
ln -s ../../../../usr/libexec/iphoneports/su pkg/var/usr/bin/su
cp files/su.pam pkg/var/usr/etc/pam.d/su

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "su-$_DPKGARCH.deb"
