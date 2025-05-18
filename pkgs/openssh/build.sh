#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --sysconfdir=/var/usr/etc/ssh --with-privsep-user="_sshd" --with-sandbox=no
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install-nokeys STRIP_OPT=
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/* sbin/* libexec/*
chmod 4711 libexec/ssh-keysign
)

mkdir -p pkg/Library/LaunchDaemons

cp files/com.openssh.sshd.plist pkg/Library/LaunchDaemons/com.openssh.sshd.plist
cp files/sshd_config pkg/var/usr/etc/ssh/sshd_config
cp files/sshd-keygen-wrapper pkg/var/usr/libexec/sshd-keygen-wrapper

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENCE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
