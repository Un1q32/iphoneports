#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc/ssh --with-privsep-user=nobody --with-sandbox=no
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install-nokeys
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/*
"$_TARGET-strip" -x usr/sbin/*
"$_TARGET-strip" -x usr/libexec/*
ldid -S"$_BSROOT/entitlements.xml" usr/bin/*
ldid -S"$_BSROOT/entitlements.xml" usr/sbin/*
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/*
chmod 4711 usr/libexec/ssh-keysign
)

cp -r DEBIAN package
cp -r files/Library package
cp files/sshd_config package/etc/ssh
cp files/sshd-keygen-wrapper package/usr/libexec
dpkg-deb -b --root-owner-group -Zgzip package openssh-9.1p1.deb
