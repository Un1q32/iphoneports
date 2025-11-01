#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; then
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

mkdir -p "$_DESTDIR/Library/LaunchDaemons"
cp files/com.openssh.sshd.plist "$_DESTDIR/Library/LaunchDaemons/com.openssh.sshd.plist"
cp files/sshd_config "$_DESTDIR/var/usr/etc/ssh/sshd_config"

installlicense "$_SRCDIR/LICENCE"

builddeb
