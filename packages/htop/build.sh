#!/bin/sh
(
cd source || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/usr --disable-unicode --disable-linux-affinity
"$_MAKE" -j8
mkdir -p "$_PKGROOT"/package/usr/bin
"$_CP" htop "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/htop > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/htop
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package htop-3.0.2.deb
