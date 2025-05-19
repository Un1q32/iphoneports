#!/bin/sh
set -e
. ../../lib.sh
(
cd src
"$_TARGET-cc" -o login -Os -flto login.c -DUSE_PAM -lpam -w
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp login "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign login
chmod 4755 login
)

mkdir -p pkg/usr/local/libexec/iphoneports pkg/var/usr/etc/pam.d
mv pkg/var/usr/bin/login pkg/usr/local/libexec/iphoneports/login
ln -s ../../../../usr/local/libexec/iphoneports/login pkg/var/usr/bin/login
cp files/login.pam pkg/var/usr/etc/pam.d/login

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE-* "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
