#!/bin/sh
rm -f "$_SDK/usr/lib/libsandbox."*
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --sysconfdir=/var/usr/etc/ssh --with-privsep-user="_sshd" --with-sandbox=no
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install-nokeys STRIP_OPT=
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/* > /dev/null 2>&1
"$_TARGET-strip" sbin/* > /dev/null 2>&1
"$_TARGET-strip" libexec/* > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/*
ldid -S"$_BSROOT/ent.xml" sbin/*
ldid -S"$_BSROOT/ent.xml" libexec/*
chmod 4711 libexec/ssh-keysign
)

mkdir -p pkg/Library/LaunchDaemons

"$_CP" files/com.openssh.sshd.plist pkg/Library/LaunchDaemons/com.openssh.sshd.plist
"$_CP" files/sshd_config pkg/var/usr/etc/ssh/sshd_config
"$_CP" files/sshd-keygen-wrapper pkg/var/usr/libexec/sshd-keygen-wrapper

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg openssh.deb
