#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
ln -s gcal usr/bin/cal
rm -rf usr/share/info
"$_TARGET-strip" usr/bin/gcal > /dev/null 2>&1
"$_TARGET-strip" usr/bin/gcal2txt > /dev/null 2>&1
"$_TARGET-strip" usr/bin/tcal > /dev/null 2>&1
"$_TARGET-strip" usr/bin/txt2gcal > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/gcal
ldid -S"$_BSROOT/ent.xml" usr/bin/gcal2txt
ldid -S"$_BSROOT/ent.xml" usr/bin/tcal
ldid -S"$_BSROOT/ent.xml" usr/bin/txt2gcal
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package gcal.deb
