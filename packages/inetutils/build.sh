#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
mkdir "$_PKGROOT/package/bin" "$_PKGROOT/package/sbin"
ln -s ../usr/bin/ping "$_PKGROOT/package/bin/ping"
ln -s ../usr/bin/ping "$_PKGROOT/package/sbin/ping"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/* > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/* > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/*
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/*
chmod 4755 usr/bin/ping
chmod 4755 usr/bin/traceroute
chmod 4755 usr/bin/rsh
chmod 4755 usr/bin/rcp
chmod 4755 usr/bin/traceroute
chmod 4755 usr/bin/rlogin
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package inetutils.deb
