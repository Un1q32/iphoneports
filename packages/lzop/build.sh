#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" src/lzop "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/lzop > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/lzop
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package lzop.deb
