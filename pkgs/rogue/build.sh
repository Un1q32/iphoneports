#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc CC="$_CC" CXX="$_CXX"
make -j4
make DESTDIR=../package install
)


(
rm packagerogue.scr
cd package || exit 1
rm -rf usr/share
"$_STRIP" -x usr/bin/rogue
ldid -S usr/bin/rogue
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package rogue-5.4.4.deb
