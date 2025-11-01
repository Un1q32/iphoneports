#!/bin/sh
. ../../files/lib.sh

(
cd src
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    privsepuser="nobody"
else
    privsepuser="_sshd"
fi
./configure --host="$_TARGET" --prefix=/var/usr --sysconfdir=/var/usr/etc/ssh --with-privsep-user="$privsepuser" --with-sandbox=no
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install-nokeys STRIP_OPT=
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/* sbin/* libexec/*
chmod 4711 libexec/ssh-keysign
)

mkdir -p pkg/Library/LaunchDaemons

cp files/com.openssh.sshd.plist pkg/Library/LaunchDaemons/com.openssh.sshd.plist
cp files/sshd_config pkg/var/usr/etc/ssh/sshd_config

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENCE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
