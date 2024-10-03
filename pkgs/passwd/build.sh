#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -o passwd -O2 passwd.c file_passwd.c stringops.c -w
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp passwd "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" passwd 2>/dev/null
ldid -S"$_ENT" passwd
chmod 4755 passwd
)

mkdir -p pkg/usr/libexec/iphoneports
mv pkg/var/usr/bin/passwd pkg/usr/libexec/iphoneports/passwd
ln -s ../../../../usr/libexec/iphoneports/passwd pkg/var/usr/bin/passwd

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg passwd.deb
