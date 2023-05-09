#!/bin/sh
(
cd source || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" bc/bc "$_PKGROOT/package/usr/bin"
"$_CP" dc/dc "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/bc > /dev/null 2>&1
"$_TARGET-strip" usr/bin/dc > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/bc
ldid -S"$_BSROOT/ent.xml" usr/bin/dc
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package bc.deb
