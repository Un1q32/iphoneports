#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" src/patch "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/patch > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/patch
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package patch.deb
