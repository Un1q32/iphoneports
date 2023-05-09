#!/bin/sh
(
cd source || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/hexedit > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/hexedit
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package hexedit.deb
