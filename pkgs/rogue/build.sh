#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
make -j4
make DESTDIR="$_PKGDIR/rogue/package" install
)


(
rm packagerogue.scr
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/rogue
ldid -S usr/bin/rogue
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package rogue-5.4.4.deb
