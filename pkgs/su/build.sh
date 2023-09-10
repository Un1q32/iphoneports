#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -o su -O2 su.c -lpam
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp su "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" su > /dev/null 2>&1
ldid -S"$_ENT" su
chmod 4755 su
)

mkdir -p pkg/usr/libexec/iphoneports pkg/etc/pam.d
mv pkg/var/usr/bin/su pkg/usr/libexec/iphoneports/su
ln -s ../../../../usr/libexec/iphoneports/su pkg/var/usr/bin/su
cp files/su.pam pkg/etc/pam.d/su

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg su.deb
