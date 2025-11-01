#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" -o su -Os -flto su.c -lpam
mkdir -p "$_DESTDIR/var/usr/bin"
cp su "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
strip_and_sign su
chmod 4755 su
)

mkdir -p "$_DESTDIR/var/usr/etc/pam.d"
cp files/su.pam "$_DESTDIR/var/usr/etc/pam.d/su"

installsuid "$_DESTDIR/var/usr/bin/su"

installlicense files/LICENSE

builddeb
