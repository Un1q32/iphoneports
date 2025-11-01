#!/bin/sh
. ../../files/lib.sh

if [ "$_SUBSYSTEM" = "macos" ] && [ "$_OSVER" -lt 1050 ]; then
    printf 'login requires at least Mac OS X 10.5\n'
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
"$_TARGET-cc" -o login -Os -flto login.c -DUSE_PAM -DUSE_BSM -lpam -lbsm -w
mkdir -p "$_DESTDIR/var/usr/bin"
cp login "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/login"
chmod 4755 "$_DESTDIR/var/usr/bin/login"

installsuid "$_DESTDIR/var/usr/bin/login"

mkdir -p "$_DESTDIR/var/usr/etc/pam.d"
cp files/login.pam "$_DESTDIR/var/usr/etc/pam.d/login"

installlicense files/LICENSE-*

builddeb
