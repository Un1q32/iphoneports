#!/bin/sh
rm -f "$_TMP/sdk/usr/lib/libsandbox."*
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc/ssh --with-privsep-user=nobody --with-sandbox=no --with-zlib=/usr/local
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install-nokeys STRIP_OPT=
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/*
"$_TARGET-strip" usr/sbin/*
"$_TARGET-strip" usr/libexec/*
ldid -S"$_BSROOT/entitlements.xml" usr/bin/*
ldid -S"$_BSROOT/entitlements.xml" usr/sbin/*
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/*
chmod 4711 usr/libexec/ssh-keysign
)

"$_CP" -r DEBIAN package
"$_CP" -r files/Library package
"$_CP" files/sshd_config package/etc/ssh
"$_CP" files/sshd-keygen-wrapper package/usr/libexec
dpkg-deb -b --root-owner-group -Zgzip package openssh-9.3p1.deb
