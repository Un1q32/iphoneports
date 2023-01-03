#!/bin/sh
(
cd source || exit 1
./configure --host=arm-apple-darwin9 --prefix=/usr --sysconfdir=/etc
make -j4
make DESTDIR=../package install
)


(
rm packagerogue.scr
cd package || exit 1
rm -rf usr/share
arm-apple-darwin9-strip -x usr/bin/rogue
ldid -S usr/bin/rogue
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package rogue-5.4.4.deb
