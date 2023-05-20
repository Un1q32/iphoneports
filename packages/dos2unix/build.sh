#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" STRIP=true CPP="$_TARGET-clang -E" DESTDIR="$_PKGROOT/package" prefix=/usr ENABLE_NLS= install -j8
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/dos2unix > /dev/null 2>&1
"$_TARGET-strip" usr/bin/unix2dos > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/dos2unix
ldid -S"$_BSROOT/ent.xml" usr/bin/unix2dos
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package dos2unix.deb
