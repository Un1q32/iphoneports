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

mkdir -p "$_DESTDIR/usr/local/libexec/iphoneports" "$_DESTDIR/var/usr/etc/pam.d"
mv "$_DESTDIR/var/usr/bin/su" "$_DESTDIR/usr/local/libexec/iphoneports/su"
ln -s ../../../../usr/local/libexec/iphoneports/su "$_DESTDIR/var/usr/bin/su"
cp files/su.pam "$_DESTDIR/var/usr/etc/pam.d/su"

mkdir -p "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"

builddeb
