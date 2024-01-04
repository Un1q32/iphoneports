#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --sysconfdir=/var/usr/etc/ssh --with-privsep-user="_sshd" --with-sandbox=no
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install-nokeys STRIP_OPT=
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip bin/* sbin/* libexec/*
ldid -S"$_ENT" bin/* sbin/* libexec/*
chmod 4711 libexec/ssh-keysign
)

mkdir -p pkg/Library/LaunchDaemons

cp files/com.openssh.sshd.plist pkg/Library/LaunchDaemons/com.openssh.sshd.plist
cp files/sshd_config pkg/var/usr/etc/ssh/sshd_config
cp files/sshd-keygen-wrapper pkg/var/usr/libexec/sshd-keygen-wrapper

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg openssh.deb
