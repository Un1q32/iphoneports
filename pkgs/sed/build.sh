#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
mkdir -p "$_PKGROOT/package/bin"
"$_CP" sed/sed "$_PKGROOT/package/usr/bin/sed"
)

(
cd package || exit 1
ln -s ../usr/bin/sed bin/sed
"$_TARGET-strip" usr/bin/sed
ldid -S"$_BSROOT/entitlements.xml" usr/bin/sed
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package sed-4.9.deb
