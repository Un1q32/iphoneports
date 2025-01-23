#!/bin/sh -e
(
cd src || exit 1
"$_TARGET-cc" -o login -Os -flto login.c -DUSE_PAM -lpam -w
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp login "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" login 2>/dev/null || true
ldid -S"$_ENT" login
chmod 4755 login
)

mkdir -p pkg/usr/libexec/iphoneports pkg/var/usr/etc/pam.d
mv pkg/var/usr/bin/login pkg/usr/libexec/iphoneports/login
ln -s ../../../../usr/libexec/iphoneports/login pkg/var/usr/bin/login
cp files/login.pam pkg/var/usr/etc/pam.d/login

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg login.deb
