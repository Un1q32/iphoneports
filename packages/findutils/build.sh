#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" find/find "$_PKGROOT/package/usr/bin"
"$_CP" xargs/xargs "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/find > /dev/null 2>&1
"$_TARGET-strip" usr/bin/xargs > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/find
ldid -S"$_BSROOT/ent.xml" usr/bin/xargs
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package findutils.deb
