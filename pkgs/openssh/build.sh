#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc/ssh --with-privsep-user=nobody --with-sandbox=no CC="$_CC" CXX="$_CXX"
make -j4
make DESTDIR="$_PKGDIR/openssh/package" install-nokeys
)

(
cd package || exit 1
rm -rf usr/share
"$_STRIP" -x usr/bin/*
"$_STRIP" -x usr/sbin/*
"$_STRIP" -x usr/libexec/*
ldid -S usr/bin/*
ldid -S usr/sbin/*
ldid -S usr/libexec/*
chmod 4711 usr/libexec/ssh-keysign
)

cp -r DEBIAN package
cp -r files/Library package
cp files/sshd_config package/etc/ssh
cp files/sshd-keygen-wrapper package/usr/libexec
dpkg-deb -b --root-owner-group -Zgzip package openssh-9.1p1.deb
